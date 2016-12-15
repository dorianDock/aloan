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
    name = ''
    unless self.first_name.nil? || self.name.nil?
      unless self.first_name.nil?
        name += self.first_name
      end
      unless self.name.nil?
        name += ' '+self.name
      end
    end
    name
  end

  def display_birth_date
    self.birth_date.nil? ? 'Birthday unknown' : (self.birth_date.strftime('%d/%m/%Y'))
  end

  def age
    if self.birth_date.nil?
      return '?'
    end
    today = Date.today
    age = today.year - self.birth_date.year
    # we remove one if the birth date is not passed yet
    age -= 1 if self.birth_date.strftime("%m%d").to_i > today.strftime("%m%d").to_i
    age
  end
end
