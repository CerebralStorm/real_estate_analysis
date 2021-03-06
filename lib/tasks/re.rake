require 'nokogiri'
require 'open-uri'

namespace :re do
  ZIP_CODES = [
    '84001', '84002', '84003', '84004', '84005', '84006', '84007', '84010', '84013', '84014', '84015',
    '84017', '84020', '84021', '84023', '84024', '84025', '84026', '84027', '84028', '84029', '84031',
    '84032', '84033', '84035', '84036', '84037', '84038', '84039', '84040', '84041', '84042', '84043',
    '84044', '84045', '84046', '84047', '84049', '84050', '84052', '84053', '84054', '84055', '84057',
    '84058', '84060', '84061', '84062', '84063', '84064', '84065', '84066', '84067', '84068', '84069',
    '84070', '84071', '84072', '84073', '84074', '84075', '84076', '84078', '84080', '84081', '84082',
    '84083', '84084', '84085', '84086', '84087', '84088', '84089', '84090', '84091', '84092', '84093',
    '84094', '84095', '84096', '84097', '84098', '84101', '84102', '84103', '84104', '84105', '84106',
    '84107', '84108', '84109', '84110', '84111', '84112', '84113', '84114', '84115', '84116', '84117',
    '84118', '84119', '84120', '84121', '84122', '84123', '84124', '84125', '84126', '84127', '84128',
    '84129', '84130', '84131', '84132', '84133', '84134', '84136', '84138', '84139', '84141', '84143',
    '84144', '84145', '84147', '84148', '84150', '84151', '84152', '84157', '84158', '84165', '84170',
    '84171', '84180', '84184', '84189', '84190', '84199', '84201', '84244', '84301', '84302', '84304',
    '84305', '84306', '84307', '84308', '84309', '84310', '84311', '84312', '84313', '84314', '84315',
    '84316', '84317', '84318', '84319', '84320', '84321', '84322', '84323', '84324', '84325', '84326',
    '84327', '84328', '84329', '84330', '84331', '84332', '84333', '84334', '84335', '84336', '84337',
    '84338', '84339', '84340', '84341', '84401', '84402', '84403', '84404', '84405', '84407', '84408',
    '84409', '84412', '84414', '84415', '84501', '84510', '84511', '84512', '84513', '84515', '84516',
    '84518', '84520', '84521', '84522', '84523', '84525', '84526', '84528', '84529', '84530', '84531',
    '84532', '84533', '84534', '84535', '84536', '84537', '84539', '84540', '84542', '84601', '84602',
    '84603', '84604', '84605', '84606', '84620', '84621', '84622', '84623', '84624', '84626', '84627',
    '84628', '84629', '84630', '84631', '84632', '84633', '84634', '84635', '84636', '84637', '84638',
    '84639', '84640', '84642', '84643', '84644', '84645', '84646', '84647', '84648', '84649', '84651',
    '84652', '84653', '84654', '84655', '84656', '84657', '84660', '84662', '84663', '84664', '84665',
    '84667', '84701', '84710', '84711', '84712', '84713', '84714', '84715', '84716', '84717', '84718',
    '84719', '84720', '84721', '84722', '84723', '84724', '84725', '84726', '84728', '84729', '84730',
    '84731', '84732', '84733', '84734', '84735', '84736', '84737', '84738', '84739', '84740', '84741',
    '84742', '84743', '84744', '84745', '84747', '84749', '84750', '84751', '84752', '84753', '84754',
    '84755', '84756', '84757', '84758', '84759', '84760', '84761', '84762', '84763', '84764', '84765',
    '84766', '84767', '84770', '84771', '84772', '84773', '84775', '84776', '84780', '84781', '84782',
    '84784', '84790', '84791'
  ]

  desc "scrapes MLS listings"
  task scrape: :environment do
    zip_codes = ZipCode.favorite.map(&:code)
    errors = []
    errors += ZillowScraper.new(zip_codes).run
    errors += UtahShortSaleScraper.new(zip_codes).run
    errors += HudHomeStoreScraper.new.run
    errors += KslScraper.new(zip_codes).run
    errors += CraigslistScraper.new(zip_codes).run
    #errors += UtahRealEstateScraper.new('http://www.utahrealestate.com/1406625').run
    errors += HomesScraper.new('http://www.homes.com/for-sale/salt-lake-city-ut/multi-family/').run
    errors += HomesScraper.new('http://www.homes.com/for-sale/sandy-ut/multi-family/').run
    errors += HomesScraper.new('http://www.homes.com/for-sale/washington-county-ut/multi-family/').run
    errors += HomesScraper.new('http://www.homes.com/for-sale/saint-george-ut/multi-family/').run
    puts errors
  end

  desc "populates zipcode data"
  task zip: :environment do
    ZipCode.all.each do |zip_code|
      Quandl.new(zip_code).run
    end
  end

  desc "posts ad to craigs list"
  task craigslist: :environment do
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(
        app,
        browser: :firefox,
        desired_capabilities: Selenium::WebDriver::Remote::Capabilities.firefox(marionette: false)
      )
    end
    session = Capybara::Session.new(:selenium)
    session.visit 'http://saltlakecity.craigslist.org/search/hsw'
    session.click_link 'post'
    session.choose 'housing wanted'
    session.choose 'real estate wanted'
    session.fill_in 'email', with: 'cerebralstorm@gmail.com'
    session.fill_in 'ConfirmEMail', with: 'cerebralstorm@gmail.com'
    session.check 'contact_text_ok'
    session.fill_in 'phone number', with: '801-637-4393'
    session.fill_in 'contact name', with: 'Cody Tanner'
    session.fill_in 'posting title', with: 'Looking to buy eastside SLC houses'
    session.fill_in 'posting body', with:
    """I am looking to purchase single family and multi family homes in the east bench area of Salt Lake City.

I have financing ready and I am perfectly happy purchasing homes that need a little TLC.

If you are interested in selling your home please text me at 801-637-4393.
    """
    session.click_button 'Continue'
    session.click_button 'done with images'
    session.within '.draft_warning' do
        session.click_button 'publish'
    end
  end
end