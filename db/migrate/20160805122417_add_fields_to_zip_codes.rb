class AddFieldsToZipCodes < ActiveRecord::Migration[5.0]
  def change
    add_column :zip_codes, :price_to_rent_ratio, :float
    add_column :zip_codes, :median_rent, :float
    add_column :zip_codes, :estimated_rent, :float
    add_column :zip_codes, :favorite, :boolean, default: false
  end
end
