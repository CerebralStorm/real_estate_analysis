class UtahRealEstateScraper
  attr_accessor :url, :errors

  def initialize(url)
    @url = url
    @errors = []
  end

  def run
    begin
      puts 'Scanning and Processing utahrealestate.com ...'
      get_properties
    rescue => e
      errors << e
    end
    errors
  end

  def get_properties(page_number = 1)
    page = Nokogiri::HTML(open("#{url}?page=#{page_number}"))
    list = page.css('div#listings')
    process_rows(list.children)
    get_properties(page_number + 1) if page.css('ul#pager').text.include?('Next')
  end

  def process_rows(rows)
    rows.each do |row|
      next unless row.text.strip.present?
      next if row.css('div')[0].text.include?('You are currently ignoring this property')
      scrape_property(row)
    end
  end

  def scrape_property(row)
    begin
      mls_number = row.attributes['id'].text
      listing = Listing.where(mls_number: mls_number).first_or_initialize
      zip_code = row.css('table.prop-overview-full').children[12].text.scan(/\d/).join('')
      address = row.css('table.prop-overview-full').children[8].text.gsub('Address:', '').squish
      listing.assign_attributes(
        address: address,
        listing_price: row.css('a.listing-estimate-mortgage').text.scan(/\d/).join(''),
        zip_code: ZipCode.where(code: zip_code).first_or_create
      )
      listing.save #if listing.changed?
    rescue => e
      errors << e
    end
  end

end
