class CreateRentalCalculations < ActiveRecord::Migration[5.0]
  def change
    create_table :rental_calculations do |t|
      t.integer :listing_id
      t.float :purchase_price
      t.float :after_repair_value
      t.float :closing_cost
      t.float :repair_cost
      t.float :interest_rate
      t.float :other_lender_charges
      t.float :lender_points
      t.integer :down_payment
      t.integer :loan_amount
      t.integer :loan_duration
      t.integer :vacancy
      t.integer :repairs
      t.integer :capital_expenditures
      t.integer :property_management
      t.integer :annual_income_growth
      t.integer :appreciation
      t.integer :annual_expense_growth
      t.integer :sales_expense

      t.timestamps
    end
  end
end
