class AddForeignKeyToLoanTemplates < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :loan_templates, :loan_templates, :column => 'template_completed_before_id', :foreign_key => 'id'
  end
end
