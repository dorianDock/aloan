class AddLoanTemplateIdToLoans < ActiveRecord::Migration[5.0]
  def change
    add_column :loans, :loan_template_id, :integer
    add_foreign_key :loans, :loan_templates, :column => 'loan_template_id', :foreign_key => 'id'
  end
end
