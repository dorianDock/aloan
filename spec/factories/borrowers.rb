# == Schema Information
#
# Table name: borrowers
#
#  id                  :integer          not null, primary key
#  name                :string
#  first_name          :string
#  company_name        :string
#  birth_date          :datetime
#  amount_wished       :float
#  project_description :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :borrower do
    name 'Borrows'
    first_name 'John'
    birth_date '1992-03-10 13:40:22'
    amount_wished 50000
    project_description 'He would like to buy enough soup to serve soup for the week each week'
  end
end
