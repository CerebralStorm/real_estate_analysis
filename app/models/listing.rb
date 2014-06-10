class Listing < ActiveRecord::Base
  before_save :calculate_computed_fields

  validate :mls_number, unique: true, presence: true

  def calculate_computed_fields
    set_zillow_fields # Do this first other fields may be dependent
    set_loan_amount
    set_price_per_sq_foot
    set_thrity_year_cash_flow
    set_fifteen_year_cash_flow
  end

  def set_loan_amount
    self.loan_amount = listing_price - down_payment
  end

  def set_price_per_sq_foot
    self.price_per_sq_foot = (listing_price/square_footage)
  end

  def set_zillow_fields
    Zillow.new(self).monthy_payment
  end

  def set_thrity_year_cash_flow
    self.thirty_year_cash_flow = (avg_rent * confidence_rate) - total_thirty_year_monthly_costs
  end

  def set_fifteen_year_cash_flow
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
