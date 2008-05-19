class CreateGuests < ActiveRecord::Migration
  def self.up
    create_table :guests do |t|
      t.integer :party_id
      t.string :name
      t.boolean :attending

      t.timestamps
    end
  end

  def self.down
    drop_table :guests
  end
end
