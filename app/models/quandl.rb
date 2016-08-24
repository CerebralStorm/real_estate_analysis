class Quandl
  include HTTParty
  base_uri "http://www.quandl.com/api/v3/"

  attr_accessor :zip_code, :start_date, :end_date, :api_key

  def initialize(zip_code)
    @api_key = 'pjXTAGd4h6NqZM_TgQSq'
    @zip_code = zip_code
  end

  def run
    return if zip_code.price_to_rent_ratio.present?
    is_valid = populate_price_to_rent_ratio
    return unless is_valid
    populate_median_rent
    populate_estimated_rent
    zip_code.save if zip_code.changed?
  end

  def populate_field(indicator_code, attribute)
    return if zip_code.send(attribute).present?
    puts "\nFinding #{attribute} for #{zip_code.code}"
    response = self.class.get("/datasets/ZILL/Z#{zip_code.code}_#{indicator_code}?api_key=#{api_key}")
    puts response
    result = false
    begin
      if response.code == 200
        zip_code.send("#{attribute}=", response['dataset']['data'].first.last)
        result = true
      end
    rescue => e
      puts e
    end
    wait
    result
  end

  def wait
    puts 'Sleeping for 30...'
    sleep 30
  end

  def populate_price_to_rent_ratio
    populate_field('PRR', :price_to_rent_ratio)
  end

  def populate_median_rent
    populate_field('RMP', :median_rent)
  end

  def populate_estimated_rent
    populate_field('RAH', :estimated_rent)
  end

end