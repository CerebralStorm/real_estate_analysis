class Listing < ActiveRecord::Base
  before_save :calculate_computed_fields

  belongs_to :zip_code

  validates :mls_number, uniqueness: true, presence: true

  scope :visible, -> { where(hide: false) }
  #add property_taxes
  def calculate_computed_fields
    set_loan_amount
    set_zillow_fields # Do this first other fields may be dependent
    set_price_per_sq_foot
    set_thrity_year_cash_flow
    set_fifteen_year_cash_flow
  end

  def full_address
    [address, city, state, zip_code].join(", ")
  end

  def set_loan_amount
    self.down_payment ||= (listing_price.to_f * 0.2).to_i
    self.loan_amount = listing_price - down_payment
  end

  def set_price_per_sq_foot
    return unless listing_price.present? and square_footage.present?
    self.price_per_sq_foot = (listing_price/square_footage)
  end

  def set_zillow_fields
    Zillow.new(self).run
  end

  def set_thrity_year_cash_flow
    return unless avg_rent.present?
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

end
