class CreateLoanTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :loan_templates do |t|
      t.float :amount
      t.float :rate
      t.integer :duration
      t.string :name
      t.integer :template_completed_before_id

      t.timestamps
    end
  end
end
