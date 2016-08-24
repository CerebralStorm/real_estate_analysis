class RemoveZipCodeFromListing < ActiveRecord::Migration[5.0]
  def change
    remove_column :listings, :zip_code
  end
end
