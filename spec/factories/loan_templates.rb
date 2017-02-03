# == Schema Information
#
# Table name: loan_templates
#
#  id                           :integer          not null, primary key
#  amount                       :float
#  rate                         :float
#  duration                     :integer
#  name                         :string
#  template_completed_before_id :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#

FactoryGirl.define do
  factory :loan_template do
    amount 1.5
    rate 1.5
    duration 1
    name "MyString"
    template_completed_before_id 1
  end
end
