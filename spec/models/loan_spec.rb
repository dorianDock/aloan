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

    it 'should be valid without a template (template is optional)' do
      @loan.loan_template_id = nil
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

  describe 'Interactions' do
    it 'belongs_to a borrower' do
      association=described_class.reflect_on_association(:borrower)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs_to a template' do
      association=described_class.reflect_on_association(:loan_template)
      expect(association.macro).to eq :belongs_to
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

  describe 'Current loans and stats on loans' do
    before(:each) do

      FactoryGirl.create(:loan_template,amount: 500000, rate: 1, duration: 1, name: '1m500k')
      FactoryGirl.create(:loan_template,amount: 500000, rate: 5, duration: 4, name: '4m500k')
      FactoryGirl.create(:loan_template,amount: 1000000, rate: 1, duration: 1, name: '1m1M', template_completed_before_id: LoanTemplate.find_by(name: '1m500k').id)
      FactoryGirl.create(:loan_template,amount: 1000000, rate: 5, duration: 4, name: '4m1M', template_completed_before_id: LoanTemplate.find_by(name: '4m500k').id)
      FactoryGirl.create(:loan_template,amount: 2000000, rate: 1, duration: 1, name: '1m2M', template_completed_before_id: LoanTemplate.find_by(name: '1m1M').id)
      FactoryGirl.create(:loan_template,amount: 2000000, rate: 5, duration: 4, name: '4m2M', template_completed_before_id: LoanTemplate.find_by(name: '4m1M').id)
      FactoryGirl.create(:loan_template,amount: 5000000, rate: 1, duration: 1, name: '1m5M', template_completed_before_id: LoanTemplate.find_by(name: '1m2M').id)
      FactoryGirl.create(:loan_template,amount: 5000000, rate: 5, duration: 4, name: '4m5M', template_completed_before_id: LoanTemplate.find_by(name: '4m2M').id)
      FactoryGirl.create(:loan_template,amount: 10000000, rate: 1, duration: 1, name: '1m10M', template_completed_before_id: LoanTemplate.find_by(name: '1m5M').id)
      FactoryGirl.create(:loan_template,amount: 10000000, rate: 5, duration: 4, name: '4m10M', template_completed_before_id: LoanTemplate.find_by(name: '4m5M').id)

      borrower1 = FactoryGirl.create(:borrower)
      borrower2 = FactoryGirl.create(:borrower)
      borrower3 = FactoryGirl.create(:borrower)
      borrower4 = FactoryGirl.create(:borrower)
      borrower5 = FactoryGirl.create(:borrower)
      borrower6 = FactoryGirl.create(:borrower)

      today = Date.today
      yesterday = Date.today-1.day
      tomorrow = Date.today+1.day
      in_one_week = Date.today+1.week
      in_two_weeks = Date.today+2.week
      in_three_weeks = Date.today+3.week
      one_week_ago = Date.today-1.week
      two_weeks_ago = Date.today-2.week
      three_weeks_ago = Date.today-3.week
      in_one_month = Date.today+1.month
      in_two_months = Date.today+2.month
      four_months_ago = Date.today-4.month
      eight_months_ago = Date.today-8.month

      # borrower 1 took 500k, then 1M, then 2M
      # borrower 2 took 1M, then 1M
      # borrower 3 took 2M, then 5M
      # borrower 4 took 500k
      # borrower 5 took 500k
      # borrower 6 took 1M
      @past_loan1= FactoryGirl.create(:loan, borrower_id: borrower1.id, start_date: eight_months_ago, contractual_end_date: four_months_ago, end_date: four_months_ago,
                                 amount: 500000, rate: 1, loan_goal: '@past_loan1',
                                      loan_template_id: LoanTemplate.find_by(name: '1m500k').id)
      @past_loan11= FactoryGirl.create(:loan, borrower_id: borrower2.id, start_date: eight_months_ago, contractual_end_date: four_months_ago, end_date: four_months_ago,
                                      amount: 1000000, rate: 1, loan_goal: '@past_loan11',
                                      loan_template_id: LoanTemplate.find_by(name: '1m1M').id)
      @past_loan2= FactoryGirl.create(:loan, borrower_id: borrower1.id, start_date: four_months_ago, contractual_end_date: yesterday, end_date: yesterday,
                                      amount: 1000000, rate: 1, loan_goal: '@past_loan2',
                                      loan_template_id: LoanTemplate.find_by(name: '1m1M').id)
      # No end date and in the past, so this one is late
      @past_loan3= FactoryGirl.create(:loan, borrower_id: borrower6.id, start_date: four_months_ago, contractual_end_date: one_week_ago,
                                      amount: 1000000, rate: 1, loan_goal: '@past_loan3',
                                      loan_template_id: LoanTemplate.find_by(name: '4m1M').id)


      @current_loan1= FactoryGirl.create(:loan, borrower_id: borrower1.id, start_date: today, contractual_end_date: in_one_month,
                                         amount: 2000000, rate: 1, loan_goal: '@current_loan1',
                                         loan_template_id: LoanTemplate.find_by(name: '1m2M').id)

      @current_loan2= FactoryGirl.create(:loan, borrower_id: borrower2.id, start_date: one_week_ago, contractual_end_date: tomorrow,
                                         amount: 1000000, rate: 1, loan_goal: '@current_loan2',
                                         loan_template_id: LoanTemplate.find_by(name: '1m1M').id)

      @current_loan3= FactoryGirl.create(:loan, borrower_id: borrower3.id, start_date: one_week_ago, contractual_end_date: in_three_weeks,
                                         amount: 2000000, rate: 1, loan_goal: '@current_loan3',
                                         loan_template_id: LoanTemplate.find_by(name: '1m2M').id)

      @current_loan4= FactoryGirl.create(:loan, borrower_id: borrower4.id, start_date: two_weeks_ago, contractual_end_date: in_two_weeks,
                                         amount: 500000, rate: 1, loan_goal: '@current_loan4',
                                         loan_template_id: LoanTemplate.find_by(name: '1m500k').id)

      @current_loan5= FactoryGirl.create(:loan, borrower_id: borrower5.id, start_date: three_weeks_ago, contractual_end_date: in_one_week,
                                         amount: 500000, rate: 1, loan_goal: '@current_loan5',
                                         loan_template_id: LoanTemplate.find_by(name: '1m500k').id)


      @future_loan1= FactoryGirl.create(:loan, borrower_id: borrower2.id, start_date: in_one_month, contractual_end_date: in_two_months,
                                        amount: 1000000, rate: 1, loan_goal: '@future_loan1',
                                        loan_template_id: LoanTemplate.find_by(name: '1m1M').id)
      @future_loan2= FactoryGirl.create(:loan, borrower_id: borrower3.id, start_date: in_three_weeks, contractual_end_date: in_two_months,
                                         amount: 5000000, rate: 1, loan_goal: '@future_loan2',
                                        loan_template_id: LoanTemplate.find_by(name: '1m5M').id)

      # preparing the test of stats
      @a_stat = Statistics.new('','')

    end

    it 'active loans count is correct' do
      # 1 past loan not paid + 5 current loans
      expect(Loan.active_loans.count).to eq(6)
    end

    it 'active loans array is correct' do
      expect(Loan.active_loans).to eq([@past_loan3,@current_loan1,@current_loan2,@current_loan3,@current_loan4,@current_loan5])
    end

    it 'active loans count is correct' do
      # 1 past loan not paid + 5 current loans
      expect(Loan.active_loans_with_templates.count).to eq(6)
    end

    it 'active loans array is correct' do
      expect(Loan.active_loans_with_templates).to eq([@past_loan3,@current_loan1,@current_loan2,@current_loan3,@current_loan4,@current_loan5])
    end



    it 'statistcs#calculate_money_outside' do
      @a_stat.calculate_money_outside
      # calculated in Millions
      expect(@a_stat.figure).to eq(7.0)
    end

    it 'statistcs#calculate_money_outside when adding a new loan' do
      borrower = FactoryGirl.create(:borrower)
      in_one_week = Date.today+1.week
      three_weeks_ago = Date.today-3.week
      @current_loan_added= FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: three_weeks_ago, contractual_end_date: in_one_week,
                                              amount: 5000000, rate: 1, loan_goal: '@current_loan_added',
                                              loan_template_id: LoanTemplate.find_by(name: '1m5M').id)

      @a_stat.calculate_money_outside
      # calculated in Millions
      expect(@a_stat.figure).to eq(12.0)
    end



    it 'statistcs#calculate_money_on_next_wave' do
      @a_stat.calculate_money_on_next_wave
      # calculated in Millions
      expect(@a_stat.figure).to eq(15.0)
    end

    it 'statistcs#calculate_money_on_next_wave when adding a new loan' do
      borrower = FactoryGirl.create(:borrower)
      in_one_week = Date.today+1.week
      three_weeks_ago = Date.today-3.week
      @current_loan_added= FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: three_weeks_ago, contractual_end_date: in_one_week,
                                              amount: 5000000, rate: 1, loan_goal: '@current_loan_added',
                                              loan_template_id: LoanTemplate.find_by(name: '1m5M').id)
      @a_stat.calculate_money_on_next_wave
      # calculated in Millions
      expect(@a_stat.figure).to eq(25.0)
    end

    it 'statistcs#calculate_rate_medium_loans' do
      @a_stat.calculate_rate_medium_loans
      # calculated in %
      expect(@a_stat.figure).to eq(100.0)
    end

    it 'statistcs#calculate_rate_medium_loans is correct when adding one loan of 5M' do
      borrower = FactoryGirl.create(:borrower)
      in_one_week = Date.today+1.week
      three_weeks_ago = Date.today-3.week
      @current_loan_added= FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: three_weeks_ago, contractual_end_date: in_one_week,
                                         amount: 5000000, rate: 1, loan_goal: '@current_loan_added',
                                         loan_template_id: LoanTemplate.find_by(name: '1m5M').id)
      @a_stat.calculate_rate_medium_loans
      # calculated in %
      expect(@a_stat.figure).to eq(58.3)
    end


  end


  describe 'Scopes' do
    before(:each) do
      borrower = FactoryGirl.create(:borrower)
      @loan1= FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: '2016-01-14 13:47:13', contractual_end_date: '2016-12-14 13:47:13',
                                amount: 1000, rate: 5, loan_goal: 'Have some money to organize trips to make new deals')
      @loan2= FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: '2016-02-14 13:47:13', contractual_end_date: '2016-12-14 13:47:13',
                                amount: 1000, rate: 5, loan_goal: 'Have some money to organize trips to make new deals')
      @loan3= FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: '2016-03-14 13:47:13', contractual_end_date: '2016-12-14 13:47:13',
                                amount: 1000, rate: 5, loan_goal: 'Have some money to organize trips to make new deals')
      @loan4= FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: '2016-04-14 13:47:13', contractual_end_date: '2016-12-14 13:47:13',
                                amount: 1000, rate: 5, loan_goal: 'Have some money to organize trips to make new deals')
      @loan5= FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: '2016-05-14 13:47:13', contractual_end_date: '2016-12-14 13:47:13',
                                amount: 1000, rate: 5, loan_goal: 'Have some money to organize trips to make new deals')
      @loan6= FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: '2016-06-14 13:47:13', contractual_end_date: '2016-12-14 13:47:13',
                                amount: 1000, rate: 5, loan_goal: 'Have some money to organize trips to make new deals')
      @loan7= FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: '2016-12-14 13:47:13', contractual_end_date: '2016-12-14 13:47:13',
                                amount: 1000, rate: 5, loan_goal: 'Have some money to organize trips to make new deals')
    end

    it 'should be ordered via start_date asc when natural order' do
      expect(Loan.natural_order.count).to eq(7)
      expect(Loan.natural_order.first).to eq(@loan1)
      expect(Loan.natural_order.second).to eq(@loan2)
      expect(Loan.natural_order.last).to eq(@loan7)
    end

    it 'should be ordered via start_date desc when reverse order' do
      expect(Loan.reverse_order.count).to eq(7)
      expect(Loan.reverse_order.first).to eq(@loan7)
      expect(Loan.reverse_order.second).to eq(@loan6)
      expect(Loan.reverse_order.last).to eq(@loan1)
    end
  end

end
