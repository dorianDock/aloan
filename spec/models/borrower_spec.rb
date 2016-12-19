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

require 'rails_helper'

RSpec.describe Borrower, type: :model do
  describe 'Interactions' do
    it 'has_many loans' do
      association=described_class.reflect_on_association(:loans)
      expect(association.macro).to eq :has_many
    end
  end

  describe 'Extensions' do
    before(:each) do
      @borrower= FactoryGirl.create(:borrower)
      @borrower.save!
    end

    it 'birthday when correct' do
      expect(@borrower.display_birth_date).to eq '10/03/1992'
    end
    it 'birthday when no birth_date' do
      @borrower.birth_date = nil
      expect(@borrower.display_birth_date).to eq 'Birthday unknown'
    end
    it 'full_name when correct' do
      expect(@borrower.full_name).to eq 'John Borrows'
    end
    it 'full_name when nothing filled' do
      @borrower.name = ''
      @borrower.first_name = ''
      expect(@borrower.full_name).to eq ''
    end
    it 'full_name when no name' do
      @borrower.name = ''
      expect(@borrower.full_name).to eq 'John'
    end
    it 'full_name when no first name' do
      @borrower.first_name = ''
      expect(@borrower.full_name).to eq 'Borrows'
    end

    it 'age when correct' do
      expect(@borrower.age).to eq 24
    end
    it 'age when no birth_date' do
      @borrower.birth_date = nil
      expect(@borrower.age).to eq '?'
    end
    it 'age when future birth_date' do
      today = Date.today
      @borrower.birth_date = today+10.days
      expect(@borrower.age).to eq '?'
    end

    it 'age when just before birth_date' do
      today = Date.today
      @borrower.birth_date = today-25.years+1.days
      expect(@borrower.age).to eq 24
    end

    it 'age when just after birth_date' do
      today = Date.today
      @borrower.birth_date = today-25.years
      expect(@borrower.age).to eq 25
    end
  end

end
