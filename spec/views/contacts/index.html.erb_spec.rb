require 'rails_helper'

RSpec.describe "contacts/index", type: :view do
  before(:each) do
    assign(:contacts, [
      Contact.create!(
        :name => "Name",
        :phone_number => "Phone Number",
        :address => "Address",
        :company => "Company",
        :profession => "Profession",
        :email => "Email"
      ),
      Contact.create!(
        :name => "Name",
        :phone_number => "Phone Number",
        :address => "Address",
        :company => "Company",
        :profession => "Profession",
        :email => "Email"
      )
    ])
  end

  it "renders a list of contacts" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Phone Number".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Company".to_s, :count => 2
    assert_select "tr>td", :text => "Profession".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
  end
end
