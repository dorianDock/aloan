# == Schema Information
#
# Table name: loans
#
#  id                   :integer          not null, primary key
#  start_date           :datetime
#  contractual_end_date :datetime
#  end_date             :datetime
#  is_late              :boolean
#  is_in_default        :boolean
#  amount               :float
#  rate                 :float
#  borrower_id          :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  loan_goal            :text
#  order                :integer          default("1")
#  loan_template_id     :integer
#

FactoryGirl.define do
  factory :loan do
    start_date '2016-12-14 13:47:13'
    contractual_end_date '2016-12-15 13:47:13'
    end_date '2017-12-14 13:47:13'
    is_late false
    is_in_default false
    amount 500000
    rate 5
    order 10
    borrower_id 1
  end
end
