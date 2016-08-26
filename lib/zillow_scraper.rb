class ZillowScraper
  attr_accessor :zip_codes, :errors

  def initialize(zip_codes)
    @zip_codes = zip_codes
    @errors = []
  end

  def run
    puts 'Scanning and Processing Zillow.com ...'
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

  def get_zipcode_properties(zip_code, page_number = 1)
    page = Nokogiri::HTML(open("http://www.zillow.com/homes/#{zip_code}_rb/house,townhouse_type/0-240000_price"))
    list = page.css('ul.photo-cards')
    list.css('article').map{ |a| "#{a.attributes['id'].text.gsub('zpid_', '')}_zpid" }
  end

  def get_listing_price(page)
    begin
      if page.css('div.home-summary-row').text.include?('Foreclosure')
        page.css('div.home-summary-row').css('span')[4].text.scan(/\d/).join('')
      else
        page.css('div.home-summary-row').css('span')[3].text.scan(/\d/).join('')
      end
    rescue => e
      errors << e
      ''
    end
  end

  def scrape_property(property_link, zip_code)
    begin
      page = Nokogiri::HTML(open("http://www.zillow.com/homes/#{property_link}"))
      mls_number = property_link
      listing = Listing.where(mls_number: mls_number).first_or_initialize
      zip_code = ZipCode.where(code: zip_code).first_or_create
      listing.assign_attributes(
        address: page.css('h1.notranslate').text,
        listing_price: get_listing_price(page),
        zip_code:zip_code,
        url: "http://www.zillow.com/homes/#{property_link}"
      )
      listing.save if listing.changed?
    rescue => e
      errors << e
    end
  end

end