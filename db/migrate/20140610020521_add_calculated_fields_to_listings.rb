class AddCalculatedFieldsToListings < ActiveRecord::Migration
  def change
    add_column :listings, :price_per_sq_foot, :float, default: 0
    add_column :listings, :price_for_even_cashflow, :float, default: 0
    add_column :listings, :down_payment, :float, default: 0
  end
end
