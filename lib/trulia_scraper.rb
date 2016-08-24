class TruliaScraper
  attr_accessor :zip_codes, :errors

  def initialize(zip_codes)
    @zip_codes = zip_codes
    @errors = []
  end

  def run
    puts 'Scanning and Processing Trulia.com ...'
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
    page = Nokogiri::HTML(open("http://www.trulia.com/for_sale/#{zip_code}_zip/0-200000_price/MULTI-FAMILY,SINGLE-FAMILY_HOME,TOWNHOUSE_type/#{page_number}_p"))
    list = page.css('div#photoView')
    results = page.css("a").select{|link| link['href'].to_s.include?('/property/') and !link['href'].to_s.include?('#map') }.map{ |link| link['href'].to_s }.uniq
    if page.css("a").select{|link| link.text.strip == 'Next' }.present?
      results += get_zipcode_properties(zip_code, page_number + 1)
    end
    results
  end

  def get_mls_number(page)
    begin
      page.css('li .listBulleted').select{ |li| li.text.include?('MLS/Source ID:') }.first.css('li').first.text.match(/\d+/).to_s
    rescue => e
      page.css("span.headingDoubleSuper").text
    end
  end

  def get_listing_price(page)
    begin
      page.css('li .listBulleted').select{ |li| li.text.include?('Price:') }.first.css('li').first.text.scan(/\d/).join('')
    rescue => e
      errors << e
    end
  end

  def get_square_footage(page)
    begin
      page.css('li .listBulleted').select{ |li| li.text.include?('sqft') and !li.text.include?('Lot Size:') }.first.css('li').select{ |li| li.text.include?('sqft') }.first.text.scan(/\d/).join('')
    rescue => e
      errors << e
    end
  end

  def scrape_property(property_link, zip_code)
    begin
      page = Nokogiri::HTML(open("http://www.trulia.com#{property_link}"))
      mls_number = get_mls_number(page)
      listing = Listing.where(mls_number: mls_number).first_or_initialize
      zip_code = ZipCode.where(code: zip_code).first_or_create
      listing.assign_attributes(
        address: page.css("span.headingDoubleSuper").text,
        listing_price: get_listing_price(page),
        square_footage: get_square_footage(page),
        zip_code:zip_code,
        url: "http://www.trulia.com#{property_link}"
      )
      listing.save if listing.changed?
    rescue => e
      errors << e
    end
  end

end