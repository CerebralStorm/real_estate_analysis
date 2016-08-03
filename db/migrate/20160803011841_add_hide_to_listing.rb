class AddHideToListing < ActiveRecord::Migration[5.0]
  def change
    add_column :listings, :hide, :boolean, default: false
    add_column :listings, :zip_code_id, :integer, index: true
    remove_column :listings :zip_code
  end
end
