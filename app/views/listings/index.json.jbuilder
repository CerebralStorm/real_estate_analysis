json.array!(@listings) do |listing|
  json.extract! listing, :id, :mls_number, :address, :listing_price, :avg_rent, :monthly_payment, :yearly_taxe, :insurance, :square_footage
  json.url listing_url(listing, format: :json)
end
