class CreateZipCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :zip_codes do |t|
      t.string :code
      t.integer :median_listing_price
      t.integer :average_listing_price

      t.timestamps
    end
  end
end
