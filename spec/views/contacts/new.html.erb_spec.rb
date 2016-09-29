require 'rails_helper'

RSpec.describe "contacts/new", type: :view do
  before(:each) do
    assign(:contact, Contact.new(
      :name => "MyString",
      :phone_number => "MyString",
      :address => "MyString",
      :company => "MyString",
      :profession => "MyString",
      :email => "MyString"
    ))
  end

  it "renders new contact form" do
    render

    assert_select "form[action=?][method=?]", contacts_path, "post" do

      assert_select "input#contact_name[name=?]", "contact[name]"

      assert_select "input#contact_phone_number[name=?]", "contact[phone_number]"

      assert_select "input#contact_address[name=?]", "contact[address]"

      assert_select "input#contact_company[name=?]", "contact[company]"

      assert_select "input#contact_profession[name=?]", "contact[profession]"

      assert_select "input#contact_email[name=?]", "contact[email]"
    end
  end
end
