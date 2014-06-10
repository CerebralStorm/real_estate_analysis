class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :mls_number
      t.string :address
      t.integer :listing_price
      t.integer :down_payment, default: 0
      t.integer :loan_amount
      t.integer :avg_rent
      t.integer :thirty_year_fixed
      t.float :thirty_year_fixed_interest_rate
      t.integer :fifteen_year_fixed
      t.float :fifteen_year_fixed_interest_rate
      t.integer :monthly_mortagage_insurance
      t.integer :monthly_property_taxes
      t.integer :monthly_hazard_insurance
      t.integer :square_footage
      t.integer :price_per_sq_foot, default: 0
      t.integer :price_for_even_cashflow, default: 0
      t.string :zip_code
      t.integer :thirty_year_cash_flow
      t.integer :fifteen_year_cash_flow
      t.float :confidence_rate, default: 0.5
      t.boolean :pmi_required, default: :false

      t.timestamps
    end
  end
end
