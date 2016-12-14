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

class StepType < ApplicationRecord
end
