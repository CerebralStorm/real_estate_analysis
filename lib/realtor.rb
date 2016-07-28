require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

Capybara.default_driver = :poltergeist
Capybara.run_server = false

class Realtor
  include Capybara::DSL
  attr_accessor :zip_codes

  def initialize(zip_codes)
    @zip_codes = zip_codes
  end

  def get_page_data(url)
    visit(url)
    Nokogiri::HTML(page.html)
  end

  def run
    puts 'Scanning and Processing Realtor.com ...'
    zip_codes.each do |zip_code|
      puts "Processing Zip: #{zip_code}"
      property_links = get_zipcode_properties(zip_code)
      binding.pry
      puts "Found #{property_links.count} properties in #{zip_code}"
      property_links.each do |property_link|
        scrape_property(property_link)
      end
    end
  end

  def get_zipcode_properties(zip_code)
    page = get_page_data("http://www.realtor.com/realestateandhomes-search/#{zip_code}/price-na-250000?pgsz=50")
    page.css('div').map{ |div| div['data-url'] }.uniq
  end

  def get_mls_number(page)
    begin
      page.css('td').select{ |td| td['itemprop'] == 'productID' }.first.text
    rescue
      get_street_address(page)
    end
  end

  def get_street_address(page)
    begin
      page.css('span').select{ |span| span['itemprop'] == 'streetAddress' }.first.text
    rescue => e
      #do nothing
      binding.pry
    end
  end

  def get_listing_price(page)
    begin
      page.css('span').select{ |span| span['itemprop'] == 'price' }.first.text.scan(/\d/).join('')
    rescue => e
      #do nothing
      binding.pry
    end
  end

  def get_square_footage(page)
    begin
      page.css('li .property-meta-block').first.text.scan(/\d/).join('')
    rescue => e
      #do nothing
      binding.pry
    end
  end

  def get_zip_code(page)
    begin
      page.css('span').select{ |span| span['itemprop'] == 'postalCode' }.first.text
    rescue => e
      binding.pry
    end
  end

  def scrape_property(property_link)
    begin
      page = get_page_data("http://www.realtor.com/#{property_link}")
      mls_number = get_mls_number(page)
      listing = Listing.where(mls_number: mls_number).first_or_initialize
      listing.assign_attributes(
        address: get_street_address(page),
        listing_price: get_listing_price(page),
        square_footage: get_square_footage(page),
        zip_code: get_zip_code(page),
      )
      listing.save!
    rescue => e
      puts "#{e} for #{property_link}"
    end
  end

end