class UtahShortSaleScraper
  attr_accessor :zip_codes, :errors

  def initialize(zip_codes)
    @zip_codes = zip_codes
    @errors = []
  end

  def run
    puts 'Scanning and Processing utahshortsale.com ...'
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
    begin
      page = Nokogiri::HTML(open("http://utahshortsale.com/cgi-bin/real?pge=newsearch&state=na&qsearch=true&allcities=&allcounty=Salt+Lake&cityupd=&action=&cord_n=&cord_w=&cord_s=&cord_e=&zoom_lvl=&allzipcodes=84106&allsubdivs=&price_lo=-1&price_hi=310000&htype=ALL&saletype=A&tot_bed_lo=0&tot_bath_lo=0&tot_sqft_lo=0&year=&garage=0&acres_lo=0&style=&high_school=&jr_school=&ele_school=&sortby=price&property_type=1&area=&zipcode=&selZips=#{zip_code}&mlsno=&altqs="))
      page.css('a').select{ |a| a.attributes['href'].text.include?('newlisting') }.map{ |a| a.attributes['href'].text }.uniq
    rescue => e
      errors << e
    end
  end

  def scrape_property(property_link, zip_code)
    begin
      page = Nokogiri::HTML(open("http://utahshortsale.com#{property_link}"))
      mls_number = page.css('div#propstyle td')[3].text
      listing = Listing.where(mls_number: mls_number).first_or_initialize
      zip_code = ZipCode.where(code: zip_code).first_or_create
      listing.assign_attributes(
        address: page.css('div#homefacts').first.children[3].text,
        listing_price: page.css('div#homefacts').first.children[1].text.scan(/\d/).join(''),
        square_footage: page.css('div#lineitem2')[1].text.scan(/\d/).join(''),
        zip_code: zip_code,
        url: "http://utahshortsale.com#{property_link}",
        type: property_type(page.css('div#propstyle').text)
      )
      listing.save if listing.changed?
    rescue => e
      errors << {property_link: property_link, error: e}
    end
  end

  def property_type(text)
    text = text.downcase
    if text.include?('condo')
      'Condo'
    elsif text.include?('single family home')
      'Single Family Home'
    elsif text.include?('townhome')
      'TownHome'
    elsif text.include?('multi family')
      'MultiFamilyProperty'
    elsif text.include?('land') || text.include?('lot')
      'Land'
    else
      'Listing'
    end
  end
end