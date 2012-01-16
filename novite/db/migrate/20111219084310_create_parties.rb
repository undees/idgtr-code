class CreateParties < ActiveRecord::Migration
  def change
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
end
