class CreateParties < ActiveRecord::Migration
  def self.up
    create_table :parties do |t|
      t.string :name
      t.text :description
      t.text :location
      t.datetime :begins_at
      t.datetime :ends_at
      t.string :permalink

      t.timestamps
    end
  end

  def self.down
    drop_table :parties
  end
end
