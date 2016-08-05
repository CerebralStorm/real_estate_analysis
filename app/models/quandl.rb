class Quandl
  include HTTParty
  base_uri "http://www.quandl.com/api/v3/"

  attr_accessor :zip_code, :start_date, :end_date, :api_key

  def initialize(zip_code)
    @api_key = 'pjXTAGd4h6NqZM_TgQSq'
    @zip_code = zip_code
  end

  def run
    populate_price_to_rent_ratio
    populate_median_rent
    populate_estimated_rent
    zip_code.save
  end

  def populate_field(indicator_code, attribute)
    return if zip_code.send(attribute).present?
    response = self.class.get("/datasets/ZILL/Z#{zip_code.code}_#{indicator_code}?apikey=#{api_key}")
    begin
      if response.code == 200
        zip_code.send("#{attribute}=", response['dataset']['data'].first.last)
      end
    rescue => e
      #noop
    ensure
      sleep 30
    end
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