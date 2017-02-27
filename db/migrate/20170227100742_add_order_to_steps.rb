class AddOrderToSteps < ActiveRecord::Migration[5.0]
  def change
    add_column :steps, :order, :integer, :default => 1
  end
end
