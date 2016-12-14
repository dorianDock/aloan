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

class Borrower < ApplicationRecord



  def full_name
    self.first_name+' '+self.name
  end

  def age
    today = Date.today
    age = today.year - self.birth_date.year
    # we remove one if the birth date is not passed yet
    age -= 1 if self.birth_date.strftime("%m%d").to_i > today.strftime("%m%d").to_i
    age
  end
end
