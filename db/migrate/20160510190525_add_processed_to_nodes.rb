class AddProcessedToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :processed_by, :string
  end
end
