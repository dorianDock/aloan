class CreateLoans < ActiveRecord::Migration[5.0]
  def change
    create_table :loans do |t|
      t.datetime :start_date
      t.datetime :contractual_end_date
      t.datetime :end_date
      t.boolean :is_late
      t.boolean :is_in_default
      t.float :amount
      t.float :rate
      t.integer :borrower_id

      t.timestamps
    end

    add_foreign_key :loans, :borrowers
  end
end
