class AddUrlToListings < ActiveRecord::Migration[5.0]
  def change
    add_column :listings, :url, :string
  end
end
