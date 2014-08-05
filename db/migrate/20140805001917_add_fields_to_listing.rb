class AddFieldsToListing < ActiveRecord::Migration
  def change
    add_column :listings, :city, :string
    add_column :listings, :state, :string
    add_column :listings, :remodel_cost, :float
    add_column :listings, :number_of_bedrooms, :integer
    add_column :listings, :potential_number_of_bedrooms, :integer
    add_column :listings, :number_of_bathrooms, :integer
    add_column :listings, :potential_number_of_bathrooms, :integer
    add_column :listings, :zpid, :string
  end
end
