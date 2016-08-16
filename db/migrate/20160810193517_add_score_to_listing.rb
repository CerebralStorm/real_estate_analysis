class AddScoreToListing < ActiveRecord::Migration[5.0]
  def change
    add_column :listings, :score, :integer
  end
end
