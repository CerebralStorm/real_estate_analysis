class HomesScraper
  attr_accessor :url, :errors

  def initialize(url)
    @url = url
    @errors = []
  end

  def run
    begin
      puts 'Scanning and Processing homes.com ...'
      get_properties
    rescue => e
      errors << e
    end
    errors
  end

  def get_properties(page_number = 1)
    current_url = page_number == 1 ? url : "#{url}/p#{page_number}/"
    page = Nokogiri::HTML(open(current_url))
    list = page.css('div.results-wrapper')
    process_rows(list.css('div.result-list'))
    get_properties(page_number + 1) if page.css('div.pagination-numbers').text.include?((page_number+1).to_s)
  end

  def process_rows(rows)
    rows.each do |row|
      scrape_property(row)
    end
  end

  def scrape_property(row)
    begin
      address = row.search('meta[itemprop="name"]').attribute('content').text
      mls_number = row.css('a')[2].attribute('listingid').text rescue address
      listing = Listing.where(mls_number: mls_number).first_or_initialize
      zip_code = ZipCode.where(code: row.search('span[itemprop="postalCode"]').text).first_or_create
      listing.assign_attributes(
        address: address,
        listing_price: row.css('div.result-price').text.scan(/\d/).join(''),
        zip_code: zip_code,
        url: "http://www.homes.com/#{row.search('a[itemprop="url"]').attribute('href').text}"
      )
      listing.save if listing.changed?
    rescue => e
      errors << {row: row, error: e}
    end
  end

end
