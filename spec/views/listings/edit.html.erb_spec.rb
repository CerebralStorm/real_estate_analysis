require 'rails_helper'

RSpec.describe "listings/edit", :type => :view do
  before(:each) do
    @listing = assign(:listing, Listing.create!(
      :mls_number => "MyString",
      :address => "MyString",
      :listing_price => 1.5,
      :avg_rent => 1.5,
      :monthly_payment => 1.5,
      :yearly_taxe => "",
      :insurance => 1.5,
      :square_footage => 1
    ))
  end

  it "renders the edit listing form" do
    render

    assert_select "form[action=?][method=?]", listing_path(@listing), "post" do

      assert_select "input#listing_mls_number[name=?]", "listing[mls_number]"

      assert_select "input#listing_address[name=?]", "listing[address]"

      assert_select "input#listing_listing_price[name=?]", "listing[listing_price]"

      assert_select "input#listing_avg_rent[name=?]", "listing[avg_rent]"

      assert_select "input#listing_monthly_payment[name=?]", "listing[monthly_payment]"

      assert_select "input#listing_yearly_taxe[name=?]", "listing[yearly_taxe]"

      assert_select "input#listing_insurance[name=?]", "listing[insurance]"

      assert_select "input#listing_square_footage[name=?]", "listing[square_footage]"
    end
  end
end
