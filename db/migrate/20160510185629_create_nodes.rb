class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :net
      t.string :name
      t.string :at
      t.string :net_id
      t.string :data

      t.timestamps null: false
    end
  end
end
