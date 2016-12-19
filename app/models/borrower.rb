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


  has_many :loans

  def full_name
    name = ''
    unless (self.first_name.nil? || self.first_name.empty?) && (self.name.nil? || self.name.empty?)
      unless self.first_name.nil? || self.first_name.empty?
        name += self.first_name
      end
      unless self.first_name.nil? || self.first_name.empty? || self.name.nil? || self.name.empty?
        name += ' '
      end
      unless self.name.nil? || self.name.empty?
        name += self.name
      end
    end
    name
  end

  def display_birth_date
    self.birth_date.nil? ? 'Birthday unknown' : (self.birth_date.strftime('%d/%m/%Y'))
  end

  def age
    today = Date.today
    if self.birth_date.nil? || self.birth_date > today
      return '?'
    end

    age = today.year - self.birth_date.year
    # we remove one if the birth date is not passed yet
    age -= 1 if self.birth_date.strftime("%m%d").to_i > today.strftime("%m%d").to_i
    age
  end
end
