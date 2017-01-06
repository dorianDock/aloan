class AddOrderToLoans < ActiveRecord::Migration[5.0]
  def change
    add_column :loans, :order, :integer
  end
end
