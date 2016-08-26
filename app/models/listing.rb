class Listing < ActiveRecord::Base
  before_save :calculate_computed_fields

  belongs_to :zip_code
  has_many :rental_calculations

  validates :mls_number, uniqueness: true, presence: true
  validates :zip_code_id, presence: true

  scope :visible, -> { where(hide: false) }
  scope :favorite, -> { where(favorite: true) }
  scope :with_cashflow, -> { where.not(avg_rent: nil) }
  scope :without_cashflow, -> { where(avg_rent: nil) }
  scope :positive_cashflow, -> { where('thirty_year_cash_flow > 0') }
  scope :below_average_price, -> { joins(:zip_code).where('listings.listing_price < zip_codes.average_listing_price') }
  scope :with_favorite_zipcode, -> { joins(:zip_code).merge(ZipCode.favorite) }
  scope :from_today, -> { where(created_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day) }

  #TODO add property_taxes
  def calculate_computed_fields
    set_loan_amount
    set_thirty_year_fixed
    set_api_fields
    set_price_per_sq_foot
    set_thrity_year_cash_flow
    set_fifteen_year_cash_flow
    set_score
  end

  def set_thirty_year_fixed
    return if thirty_year_fixed.present?
    term = 12 * 30
    r = (self.thirty_year_fixed_interest_rate || 3.5) / 1200
    n = r * self.loan_amount # Numerator
    d = 1 - (1 + r)**-term # Denominator
    self.thirty_year_fixed = n / d
  end

  def full_address
    [address, city, state, zip].compact.join(", ")
  end

  def zip
    zip_code.try(:code)
  end

  def set_loan_amount
    self.down_payment = (listing_price.to_f * 0.2).to_i
    self.loan_amount = listing_price - down_payment
  end

  def set_price_per_sq_foot
    return unless listing_price.present? and square_footage.present?
    self.price_per_sq_foot = (listing_price/square_footage)
  end

  def set_api_fields
    Zillow.new(self).run
    Trulia.new(self).run
  end

  def set_thrity_year_cash_flow
    self.avg_rent ||= zip_code.try(:estimated_rent)
    return unless self.avg_rent.present?
    self.thirty_year_cash_flow = (avg_rent * confidence_rate) - total_thirty_year_monthly_costs
  end

  def set_fifteen_year_cash_flow
    return unless avg_rent.present?
    self.fifteen_year_cash_flow = (avg_rent * confidence_rate) - total_fifteen_year_monthly_costs
  end

  def total_thirty_year_monthly_costs
    total = thirty_year_fixed.to_i + monthly_property_taxes.to_i  + monthly_hazard_insurance.to_i
    total += monthly_mortagage_insurance.to_i if pmi_required?
    total
  end

  def total_fifteen_year_monthly_costs
    total = fifteen_year_fixed.to_i + monthly_property_taxes.to_i  + monthly_hazard_insurance.to_i
    total += monthly_mortagage_insurance.to_i  if pmi_required?
    total
  end

  def set_score
    return unless zip_code.present?
    cash_score = 2 * (thirty_year_cash_flow || 0)/10
    area_price = ((zip_code.median_listing_price || 0)/10000)/2
    zip_code_score = ZipCode.favorite.map(&:id).include?(zip_code_id) ? 20 : 0
    self.score = cash_score + area_price + zip_code_score
  end

end
