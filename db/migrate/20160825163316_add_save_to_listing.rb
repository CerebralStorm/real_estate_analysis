class AddSaveToListing < ActiveRecord::Migration[5.0]
  def change
    add_column :listings, :favorite, :boolean, default: false
  end
end
