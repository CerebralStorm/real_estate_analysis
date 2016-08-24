class CraigslistScraper
  attr_accessor :zip_codes, :errors

  def initialize(zip_codes)
    @zip_codes = zip_codes
    @errors = []
  end

  def run
    puts 'Scanning and Processing Craigslist.com ...'
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

  def get_zipcode_properties(zip_code, set_number = 100)
    page = Nokogiri::HTML(open("https://saltlakecity.craigslist.org/search/rea?postal=#{zip_code}&min_price=0&max_price=300000"))
    page.css('a').select{ |a| a.attributes['href'].text.include?('/reb/') }.map{ |a| a.attributes['href'].text }
  end

  def scrape_property(property_link, zip_code)
    begin
      page = Nokogiri::HTML(open("https://saltlakecity.craigslist.org#{property_link}"))
      mls_number = property_link.gsub('/reb/', '').gsub('.html', '')
      listing = Listing.where(mls_number: mls_number).first_or_initialize
      zip_code = ZipCode.where(code: zip_code).first_or_create
      address = page.css('span#titletextonly').text
      listing.assign_attributes(
        address: address,
        listing_price: page.css('span.price').text.scan(/\d/).join(''),
        zip_code: zip_code,
        url: "https://saltlakecity.craigslist.org#{property_link}"
      )
      listing.save if listing.changed?
    rescue => e
      errors << e
    end
  end

end
