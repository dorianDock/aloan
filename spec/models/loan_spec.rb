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
#

require 'rails_helper'

RSpec.describe Loan, type: :model do
  describe 'Validation' do
    before(:each) do
      borrower = FactoryGirl.create(:borrower)
      @loan= FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: '2016-12-14 13:47:13', contractual_end_date: '2016-12-14 13:47:13',
                                amount: 1000, rate: 5, loan_goal: 'Have some money to organize trips to make new deals')
    end

    it 'should be valid with a borrower, a start_date, a contractual_end_date, an amount and a rate' do
      expect(@loan).to be_valid
    end

    it 'should not be valid if the borrower is missing' do
      @loan.borrower_id=nil
      expect(@loan).to_not be_valid
    end

    it 'should not be valid if the start date is missing' do
      @loan.start_date=nil
      expect(@loan).to_not be_valid
    end

    it 'should not be valid if the contractual end date is missing' do
      @loan.contractual_end_date=nil
      expect(@loan).to_not be_valid
    end

    it 'should not be valid if the amount is missing' do
      @loan.amount=nil
      expect(@loan).to_not be_valid
    end

    it 'should not be valid if the rate is missing' do
      @loan.rate=nil
      expect(@loan).to_not be_valid
    end
  end

end
