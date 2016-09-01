class AddNotesToListing < ActiveRecord::Migration[5.0]
  def change
    add_column :listings, :notes, :text
  end
end
