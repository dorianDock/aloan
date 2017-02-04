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


  describe 'Methods' do
    before(:each) do
      @borrower = FactoryGirl.create(:borrower)
      @loan= FactoryGirl.create(:loan, borrower_id: @borrower.id, start_date: '2016-12-14 00:00:00', contractual_end_date: '2016-12-24 00:00:00')
    end

    it 'loan#beginning_difference_days' do
      now = Time.now
      res = (@loan.start_date.to_i-now.to_i)/(3600*24)+1
      expect(@loan.beginning_difference_days).to eq(res)
    end

    it 'loan#end_difference_days' do
      now = Time.now
      res = (@loan.contractual_end_date.to_i-now.to_i)/(3600*24)+1
      expect(@loan.end_difference_days).to eq(res)
    end

    it 'loan#interest' do
      expect(@loan.interest).to eq(25000)
    end

    it 'loan#loan_duration' do
      expect(@loan.loan_duration).to eq(10)
    end

    it 'loan#loan_duration_in_months' do
      expect(@loan.loan_duration_in_months).to eq(0)
    end

    it 'duration in months works for 2 months' do
      a_loan= FactoryGirl.create(:loan, borrower_id: @borrower.id, start_date: '2016-01-14 00:00:00', contractual_end_date: '2016-03-17 00:00:00')
      expect(a_loan.loan_duration_in_months).to eq(2)
    end

    it 'duration in months works for 1.5 months' do
      a_loan= FactoryGirl.create(:loan, borrower_id: @borrower.id, start_date: '2017-01-01 00:00:00', contractual_end_date: '2017-02-14 00:00:00')
      expect(a_loan.loan_duration_in_months).to eq(1.5)
    end

    it 'duration in months works for 14 months' do
      a_loan= FactoryGirl.create(:loan, borrower_id: @borrower.id, start_date: '2017-01-11 00:00:00', contractual_end_date: '2018-03-11 00:00:00')
      expect(a_loan.loan_duration_in_months).to eq(14)
    end

  end

end
