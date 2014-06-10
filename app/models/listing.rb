class Listing < ActiveRecord::Base
  before_save :set_price_per_sq_foot
  before_save :set_price_for_even_cashflow

  def loan_price
    listing_price - down_payment
  end

  def set_price_per_sq_foot
    price_per_sq_foot = (listing_price/square_footage)
  end

  def set_price_for_even_cashflow
    avg_rent - total_monthly_costs
    price_for_even_cashflow
  end

  def total_monthly_costs
    monthly_payment + monthly_tax_cost + insurance
  end

  def monthly_tax_cost
    yearly_tax / 12
  end
end
