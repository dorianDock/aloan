class AddMonthsAfterPreviousMilestoneToSteps < ActiveRecord::Migration[5.0]
  def change
    add_column :steps, :months_after_previous_milestone, :integer
  end
end
