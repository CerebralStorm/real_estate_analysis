class Zillow
  include HTTParty
  base_uri "http://www.zillow.com/webservice/"

  attr_accessor :action, :options, :listing

  def initialize(listing)
    @listing = listing
    @options = {
      query: {
        'zws-id' => "X1-ZWz1dudqjorx8r_5rw5j",
        price: listing.listing_price,
        dollarsdown: listing.down_payment,
        zip: listing.zip_code,
        output: 'json'
      }
    }
  end

  def monthy_payment
    response = self.class.get("/GetMonthlyPayments.htm", @options)
    if response.code == 200
      response_hash = response['response']
      listing.thirty_year_fixed = response_hash['thirtyYearFixed']['monthlyPrincipalAndInterest']
      listing.thirty_year_fixed_interest_rate = response_hash['thirtyYearFixed']['rate']
      listing.fifteen_year_fixed = response_hash['fifteenYearFixed']['monthlyPrincipalAndInterest']
      listing.fifteen_year_fixed_interest_rate = response_hash['fifteenYearFixed']['rate']
      listing.monthly_property_taxes = response_hash['monthlyPropertyTaxes']
      listing.monthly_hazard_insurance = response_hash['monthlyHazardInsurance']
    end
  end

end