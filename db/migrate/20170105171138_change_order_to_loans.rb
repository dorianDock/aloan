class ChangeOrderToLoans < ActiveRecord::Migration[5.0]
  def change
    change_column :loans, :order, :integer, :default => 1
  end
end
