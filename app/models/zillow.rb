class Zillow
  include HTTParty
  base_uri "http://www.zillow.com/webservice/"

  attr_accessor :action, :listing

  def initialize(listing)
    @listing = listing
  end

  def run
    #monthy_payment
    search_result
    #comp
  end

  def monthly_payment_options
    {
      query: {
        'zws-id' => "X1-ZWz1dudqjorx8r_5rw5j",
        price: listing.listing_price,
        dollarsdown: listing.down_payment,
        zip: listing.zip,
        output: 'json'
      }
    }
  end

  def monthy_payment
    response = self.class.get("/GetMonthlyPayments.htm", monthly_payment_options)
    begin
      if response.code == 200
        response_hash = response['response']
        listing.thirty_year_fixed = response_hash['thirtyYearFixed']['monthlyPrincipalAndInterest']
        listing.thirty_year_fixed_interest_rate = response_hash['thirtyYearFixed']['rate']
        listing.fifteen_year_fixed = response_hash['fifteenYearFixed']['monthlyPrincipalAndInterest']
        listing.fifteen_year_fixed_interest_rate = response_hash['fifteenYearFixed']['rate']
        listing.monthly_property_taxes = response_hash['monthlyPropertyTaxes']
        listing.monthly_hazard_insurance = response_hash['monthlyHazardInsurance']
      end
    rescue => e
      #noop
    end
  end

  def search_result_options(listing)
    {
      query: {
        'zws-id' => "X1-ZWz1dudqjorx8r_5rw5j",
        address: listing.address,
        citystatezip: listing.zip,
        rentzestimate: true,
        output: 'json'
      }
    }
  end

  def search_result
    return if listing.avg_rent.present?
    begin
      response = self.class.get("/GetSearchResults.htm", search_result_options)
      if response.code == 200 && response['searchresults'].has_key?('response')
        results = response['searchresults']['response']['results']
        results = results.has_key?('result') ? results['result'] : results
        result = results.kind_of?(Array) ? results[0] : results
        listing.avg_rent = (result['rentzestimate']['valuationRange']['low']['__content__']).to_i rescue listing.avg_rent || listing.zip_code.try(:estimated_rent)
        listing.zpid = result['zpid']
        listing.city = result['address']['city']
        listing.state = result['address']['state']
      end
    rescue => e
      #noop
    end
  end

  # def comp_options
  #   {
  #     query: {
  #       'zws-id' => "X1-ZWz1dudqjorx8r_5rw5j",
  #       zpid: listing.zpid,
  #       count: 10,
  #       rentzestimate: true,
  #       output: 'json'
  #     }
  #   }
  # end

  # def comp
  #   response = self.class.get("/GetComps.htm", comp_options)
  #   if response.code == 200
  #     binding.pry
  #   end
  # end

end