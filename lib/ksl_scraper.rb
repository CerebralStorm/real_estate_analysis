class KslScraper
  attr_accessor :zip_codes, :errors

  def initialize(zip_codes)
    @zip_codes = zip_codes
    @errors = []
  end

  def run
    puts 'Scanning and Processing ksl.com ...'
    zip_codes.each do |zip_code|
      puts "Processing Zip: #{zip_code}"
      property_links = get_zipcode_properties(zip_code)
      puts "Found #{property_links.count} properties in #{zip_code}"
      property_links.each do |property_link|
        scrape_property(property_link, zip_code)
      end
    end
    errors
  end

  def get_zipcode_properties(zip_code, attempts = 1)
    begin
      page = Nokogiri::HTML(open("http://www.ksl.com/homes/search/?zip=#{zip_code}&priceFrom=1&priceTo=240000&perPage=96"))
      list = page.css('div.listing-group')
      results = list.css('h2.address a').map{ |listing| listing.attributes['href'].text }
      results
    rescue => e
      if attempts == 1
        puts "Error pulling properties: #{e}, retrying..."
        get_zipcode_properties(zip_code, attempts + 1)
      else
        puts "Skipping #{zip_code}"
        errors << e
      end
    end
  end

  def get_mls_number(page)
    begin
      page.css('ul.listing-info li')[0].text.strip
    rescue => e
      errors << e
    end
  end

  def get_listing_price(page)
    begin
      page.css('h3.price').text.scan(/\d/).join('')
    rescue => e
      errors << e
    end
  end

  def scrape_property(property_link, zip_code)
    begin
      #TODO filter type to remove condos etc.
      page = Nokogiri::HTML(open("http://www.ksl.com#{property_link}"))
      mls_number = get_mls_number(page)
      listing = Listing.where(mls_number: mls_number).first_or_initialize
      zip_code = ZipCode.where(code: zip_code).first_or_create
      listing.assign_attributes(
        address: page.css('h2.address').text.strip,
        listing_price: get_listing_price(page),
        zip_code:zip_code,
        url: "http://www.ksl.com#{property_link}"
      )
      listing.save if listing.changed?
    rescue => e
      errors << e
    end
  end

end