class HudHomeStoreScraper
  attr_accessor :zip_codes

  def initialize
  end

  def run
    puts 'Scanning and Processing hudhomestore.com ...'
    get_properties
  end

  def get_properties(page_number = 1)
    page = Nokogiri::HTML(open("https://www.hudhomestore.com/Listing/PropertySearchResult.aspx?pageId=#{page_number}&zipCode=&city=&county=&sState=UT&fromPrice=0&toPrice=0&fcaseNumber=&bed=0&bath=0&street=&buyerType=0&specialProgram=&Status=0&indoorAmenities=&outdoorAmenities=&housingType=&stories=&parking=&propertyAge=&sLanguage=ENGLISH"))
    list = page.css('#List')
    process_rows(list.css('tr.FormTableRow'))
    process_rows(list.css('tr.FormTableRowAlt'))
    get_properties(page_number + 1) if page.css('a.FormPageNumb').map { |a| a.text.to_i }.include?(page_number+1)
  end

  def process_rows(rows)
    rows.each do |row|
      scrape_property(row)
    end
  end

  def scrape_property(row)
    begin
      mls_number = row.css('td')[1].text.strip
      listing = Listing.where(mls_number: mls_number).first_or_initialize
      zip_code = row.css('td')[2].text.strip.split(',').last.scan(/\d/).join('')
      address = [row.css('td')[2].children[1].children[0], row.css('td')[2].children[1].children[2]].join(' ')
      listing.assign_attributes(
        address: address,
        listing_price: row.css('td')[3].text.scan(/\d/).join(''),
        zip_code: ZipCode.where(code: zip_code).first_or_create,
        hud: true
      )
      listing.save if listing.changed?
    rescue => e
      puts "#{e} for #{property_link}"
    end
  end

end
