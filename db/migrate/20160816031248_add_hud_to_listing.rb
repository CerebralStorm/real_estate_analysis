class AddHudToListing < ActiveRecord::Migration[5.0]
  def change
    add_column :listings, :hud, :boolean, default: false
  end
end
