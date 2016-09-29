require 'rails_helper'

RSpec.describe "contacts/edit", type: :view do
  before(:each) do
    @contact = assign(:contact, Contact.create!(
      :name => "MyString",
      :phone_number => "MyString",
      :address => "MyString",
      :company => "MyString",
      :profession => "MyString",
      :email => "MyString"
    ))
  end

  it "renders the edit contact form" do
    render

    assert_select "form[action=?][method=?]", contact_path(@contact), "post" do

      assert_select "input#contact_name[name=?]", "contact[name]"

      assert_select "input#contact_phone_number[name=?]", "contact[phone_number]"

      assert_select "input#contact_address[name=?]", "contact[address]"

      assert_select "input#contact_company[name=?]", "contact[company]"

      assert_select "input#contact_profession[name=?]", "contact[profession]"

      assert_select "input#contact_email[name=?]", "contact[email]"
    end
  end
end
