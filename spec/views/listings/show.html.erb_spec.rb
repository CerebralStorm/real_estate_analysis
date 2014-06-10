require 'rails_helper'

RSpec.describe "listings/show", :type => :view do
  before(:each) do
    @listing = assign(:listing, Listing.create!(
      :mls_number => "Mls Number",
      :address => "Address",
      :listing_price => 1.5,
      :avg_rent => 1.5,
      :monthly_payment => 1.5,
      :yearly_taxe => "",
      :insurance => 1.5,
      :square_footage => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Mls Number/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(//)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1/)
  end
end
