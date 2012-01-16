class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.integer :party_id
      t.string :name
      t.boolean :attending

      t.timestamps
    end
  end
end
