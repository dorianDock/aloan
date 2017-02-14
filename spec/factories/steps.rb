# == Schema Information
#
# Table name: steps
#
#  id                              :integer          not null, primary key
#  loan_id                         :integer
#  step_type_id                    :integer
#  expected_date                   :datetime
#  date_done                       :datetime
#  is_done                         :boolean
#  amount                          :float
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  loan_template_id                :integer
#  days_after_previous_milestone   :integer
#  months_after_previous_milestone :integer
#

FactoryGirl.define do
  factory :step do
    loan_id 1
    step_type_id 1
    expected_date "2016-12-14 14:51:58"
    date_done "2016-12-14 14:51:58"
    is_done false
    amount 70000
  end
end
