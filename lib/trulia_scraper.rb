class TruliaScraper
  attr_accessor :zip_codes

  def initialize(zip_codes)
    @zip_codes = zip_codes
  end

  def run
    puts 'Scanning and Processing Trulia.com ...'
    zip_codes.each do |zip_code|
      puts "Processing Zip: #{zip_code}"
      property_links = get_zipcode_properties(zip_code)
      puts "Found #{property_links.count} properties in #{zip_code}"
      property_links.each do |property_link|
        scrape_property(property_link)
      end
    end
  end

  def get_zipcode_properties(zip_code)
    page = Nokogiri::HTML(open("http://www.trulia.com/for_sale/#{zip_code}_zip/0-200000_price/MULTI-FAMILY,SINGLE-FAMILY_HOME,TOWNHOUSE_type/"))
    list = page.css('div#photoView')
    page.css("a").select{|link| link['href'].to_s.include?('/property/') and !link['href'].to_s.include?('#map') }.map{ |link| link['href'].to_s }.uniq
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
      #do nothing
    end
  end

  def get_square_footage(page)
    begin
      page.css('li .listBulleted').select{ |li| li.text.include?('sqft') and !li.text.include?('Lot Size:') }.first.css('li').select{ |li| li.text.include?('sqft') }.first.text.scan(/\d/).join('')
    rescue
      #do nothing
    end
  end

  def get_zip_code(page)
    begin
      page.css('span .pls').select{ |span| span['itemprop'] == 'postalCode' }.first.text
    rescue => e
      binding.pry
    end
  end

  def scrape_property(property_link)
    begin
      page = Nokogiri::HTML(open("http://www.trulia.com#{property_link}"))
      mls_number = get_mls_number(page)
      listing = Listing.where(mls_number: mls_number).first_or_initialize
      listing.assign_attributes(
        address: page.css("span.headingDoubleSuper").text,
        listing_price: get_listing_price(page),
        square_footage: get_square_footage(page),
        zip_code: ZipCode.where(code: get_zip_code(page)).first_or_create,
      )
      listing.save!
    rescue => e
      puts "#{e} for #{property_link}"
    end
  end

end