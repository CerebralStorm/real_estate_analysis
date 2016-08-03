class Trulia
  include HTTParty
  base_uri "http://api.trulia.com/webservices.php"

  attr_accessor :listing, :start_date, :end_date, :api_key

  def initialize(listing)
    @start_date = 1.month.ago.strftime('%Y-%m-%d')
    @end_date = Time.now.strftime('%Y-%m-%d')
    @api_key = '5h942wh63e5a6mdv7njdzesb'
    @listing = listing
  end

  def run
    zip_code_info
  end

  def zip_code_info
    return unless listing.zip_code.present?
    response = self.class.get("?library=TruliaStats&function=getZipCodeStats&zipCode=#{listing.zip_code.code}&startDate=#{start_date}&endDate=#{end_date}&apikey=#{api_key}")
    begin
      if response.code == 200
        zip_code = listing.zip_code
        response_hash = response['TruliaWebServices']['response']
        listing_stats_week = response_hash['TruliaStats']['listingStats']['listingStat'].last
        listing_stats_week['listingPrice']['subcategory'].first
        all_property_stats = listing_stats_week['listingPrice']['subcategory'].first
        zip_code.median_listing_price = all_property_stats['medianListingPrice']
        zip_code.average_listing_price = all_property_stats['averageListingPrice']
        zip_code.save

        #TODO show similar properties if listing.number_of_bedrooms.present?

      end
    rescue => e
      binding.pry
      #noop
    end
  end

end