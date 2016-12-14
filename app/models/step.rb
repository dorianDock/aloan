# == Schema Information
#
# Table name: steps
#
#  id            :integer          not null, primary key
#  loan_id       :integer
#  step_type_id  :integer
#  expected_date :datetime
#  date_done     :datetime
#  is_done       :boolean
#  amount        :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Step < ApplicationRecord
end
