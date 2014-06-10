class Zillow
  include HTTParty
  base_uri "http://www.zillow.com/webservice/"

  attr_accessor :action, :options

  def initialize
    #@options = { query: {'zws-id': "TODO"} }
  end

end