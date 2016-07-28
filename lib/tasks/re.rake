require 'nokogiri'
require 'open-uri'

namespace :re do


  desc "scrapes MLS listings"
  task scrape: :environment do
    zip_codes = [
      '84103',
      '84102',
      '84105',
      '84106',
      '84108',
      '84109',
      '84124',
      '84117',
      '84121',
      '84093',
      '84092',
    ]

    #Trulia.new(zip_codes).run
    Realtor.new(zip_codes).run
  end
end