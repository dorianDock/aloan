class AddLoanGoalToLoans < ActiveRecord::Migration[5.0]
  def change
    add_column :loans, :loan_goal, :text
  end
end
