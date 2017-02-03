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

class LoanTemplate < ApplicationRecord
end
