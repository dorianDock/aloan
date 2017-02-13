class AddDaysAfterPreviousMilestoneToSteps < ActiveRecord::Migration[5.0]
  def change
    add_column :steps, :days_after_previous_milestone, :integer
  end
end
