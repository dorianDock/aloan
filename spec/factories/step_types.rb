# == Schema Information
#
# Table name: step_types
#
#  id          :integer          not null, primary key
#  label       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :step_type do
    label 'Freeing Money'
    description 'We give to the customer the money corresponding to the loan'
  end
end
