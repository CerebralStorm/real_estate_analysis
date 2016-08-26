class AddFieldsToRentalCalculations < ActiveRecord::Migration[5.0]
  def change
    add_column :rental_calculations, :annual_property_taxes, :float
    add_column :rental_calculations, :annual_property_value_growth, :float
    add_column :rental_calculations, :monthly_rent, :float
    add_column :rental_calculations, :monthly_electricity, :float
    add_column :rental_calculations, :monthly_water_and_sewer, :float
    add_column :rental_calculations, :private_mortagage_insurance, :float
    add_column :rental_calculations, :garbage, :float
    add_column :rental_calculations, :monthly_hoa, :float
    add_column :rental_calculations, :other_monthly_costs, :float
  end
end
