class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :mls_number
      t.string :address
      t.float :listing_price
      t.float :avg_rent
      t.float :monthly_payment
      t.float :yearly_tax
      t.float :insurance
      t.integer :square_footage

      t.timestamps
    end
  end
end
