require 'rails_helper'

RSpec.describe "contacts/show", type: :view do
  before(:each) do
    @contact = assign(:contact, Contact.create!(
      :name => "Name",
      :phone_number => "Phone Number",
      :address => "Address",
      :company => "Company",
      :profession => "Profession",
      :email => "Email"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Phone Number/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/Company/)
    expect(rendered).to match(/Profession/)
    expect(rendered).to match(/Email/)
  end
end
