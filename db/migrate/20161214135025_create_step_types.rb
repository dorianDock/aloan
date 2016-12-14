class CreateStepTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :step_types do |t|
      t.string :label
      t.text :description

      t.timestamps
    end
  end
end
