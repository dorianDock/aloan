class CreateBorrowers < ActiveRecord::Migration[5.0]
  def change
    create_table :borrowers do |t|
      t.string :name
      t.string :first_name
      t.string :company_name
      t.datetime :birth_date
      t.float :amount_wished
      t.text :project_description

      t.timestamps
    end
  end
end
