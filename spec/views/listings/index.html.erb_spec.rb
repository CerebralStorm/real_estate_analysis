require 'rails_helper'

RSpec.describe "listings/index", :type => :view do
  before(:each) do
    assign(:listings, [
      Listing.create!(
        :mls_number => "Mls Number",
        :address => "Address",
        :listing_price => 1.5,
        :avg_rent => 1.5,
        :monthly_payment => 1.5,
        :yearly_taxe => "",
        :insurance => 1.5,
        :square_footage => 1
      ),
      Listing.create!(
        :mls_number => "Mls Number",
        :address => "Address",
        :listing_price => 1.5,
        :avg_rent => 1.5,
        :monthly_payment => 1.5,
        :yearly_taxe => "",
        :insurance => 1.5,
        :square_footage => 1
      )
    ])
  end

  it "renders a list of listings" do
    render
    assert_select "tr>td", :text => "Mls Number".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
