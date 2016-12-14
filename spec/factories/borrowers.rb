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
    name "MyString"
    first_name "MyString"
    birth_date "2016-12-14 13:40:22"
    amount_wished 1.5
    project_description "MyText"
  end
end
