class CreateSteps < ActiveRecord::Migration[5.0]
  def change
    create_table :steps do |t|
      t.integer :loan_id
      t.integer :step_type_id
      t.datetime :expected_date
      t.datetime :date_done
      t.boolean :is_done
      t.float :amount

      t.timestamps
    end

    add_foreign_key :steps, :loans
    add_foreign_key :steps, :step_types
    
  end



end
