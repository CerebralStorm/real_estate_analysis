class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :phone_number
      t.string :address
      t.string :company
      t.string :profession
      t.string :email

      t.timestamps
    end
  end
end
