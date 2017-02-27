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
      borrower7 = FactoryGirl.create(:borrower)

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
      one_month_and_a_half_ago = Date.today-1.month-2.week

      # borrower 1 took 500k, then 1M, then 2M
      # borrower 2 took 1M, then 1M
      # borrower 3 took 2M, then 5M
      # borrower 4 took 500k
      # borrower 5 took 500k
      # borrower 6 took 1M
      @past_loan0= FactoryGirl.create(:loan, borrower_id: borrower7.id, start_date: eight_months_ago, contractual_end_date: one_week_ago, end_date: one_week_ago,
                                      amount: 1400000, rate: 1, loan_goal: '@past_loan0')
      @past_loan00= FactoryGirl.create(:loan, borrower_id: borrower7.id, start_date: eight_months_ago, contractual_end_date: one_week_ago, end_date: one_week_ago,
                                      amount: 1100000, rate: 1, loan_goal: '@past_loan00')
      @past_loan000= FactoryGirl.create(:loan, borrower_id: borrower7.id, start_date: eight_months_ago, contractual_end_date: one_week_ago, end_date: one_week_ago,
                                      amount: 4500000, rate: 1, loan_goal: '@past_loan000')

      @past_loan1= FactoryGirl.create(:loan, borrower_id: borrower1.id, start_date: eight_months_ago, contractual_end_date: four_months_ago,
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

    it 'loan#loan_status for a running loan' do

      expect(@past_loan3.loan_status).to eq(:active)
      expect(@current_loan2.loan_status).to eq(:active)
    end

    it 'loan#loan_status for a late loan' do
      expect(@past_loan1.loan_status).to eq(:late)
    end

    it 'loan#loan_status for a finished loan' do
      expect(@past_loan11.loan_status).to eq(:finished)
    end

    it 'loan#loan_status for a planned loan' do
      expect(@future_loan1.loan_status).to eq(:planned)
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


    it 'finished loans count is correct' do
      expect(Loan.finished_loans.count).to eq(5)
    end

    it 'finished loans in the year count is correct' do
      expect(Loan.finished_loans_in_the_year.count).to eq(4)
    end


    it 'statistcs#calculate_cumulative_interests' do
      @a_stat.calculate_cumulative_interests
      # calculated in Thousands
      expect(@a_stat.figure).to eq(90.0)
    end

    it 'statistcs#calculate_cumulative_interests when removing a loan' do
      @past_loan0.delete
      @a_stat.calculate_cumulative_interests
      # calculated in Thousands
      expect(@a_stat.figure).to eq(76.0)
    end

    it 'statistcs#calculate_cumulative_interests when adding a loan' do
      borrower7 = FactoryGirl.create(:borrower)

      eight_months_ago = Date.today-8.month
      one_month_and_a_half_ago = Date.today-1.month-2.week
      @past_loan000= FactoryGirl.create(:loan, borrower_id: borrower7.id, start_date: eight_months_ago, contractual_end_date: one_month_and_a_half_ago, end_date: one_month_and_a_half_ago,
                                        amount: 4500000, rate: 1, loan_goal: '@past_loan000')
      @a_stat.calculate_cumulative_interests
      # calculated in Thousands
      expect(@a_stat.figure).to eq(135.0)
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


    it 'statistcs#calculate_money_outside when removing a current loan' do
      @current_loan2.delete
      @a_stat.calculate_money_outside
      # calculated in Millions
      expect(@a_stat.figure).to eq(6.0)
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

    it 'statistcs#calculate_money_on_next_wave when removing an existing loan' do
      @current_loan2.delete
      @future_loan1.delete
      @a_stat.calculate_money_on_next_wave
      # calculated in Millions
      expect(@a_stat.figure).to eq(14.0)
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

    it 'statistcs#calculate_rate_medium_loans is correct when removing a current loan and adding a 5M one' do
      @current_loan2.delete
      borrower = FactoryGirl.create(:borrower)
      in_one_week = Date.today+1.week
      three_weeks_ago = Date.today-3.week
      @current_loan_added= FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: three_weeks_ago, contractual_end_date: in_one_week,
                                              amount: 5000000, rate: 1, loan_goal: '@current_loan_added',
                                              loan_template_id: LoanTemplate.find_by(name: '1m5M').id)

      @a_stat.calculate_rate_medium_loans
      # calculated in %
      expect(@a_stat.figure.round(1)).to eq(54.5)
    end

    it 'statistcs#calculate_rate_very_big_loans' do
      @a_stat.calculate_rate_very_big_loans
      # calculated in %
      expect(@a_stat.figure.round(1)).to eq(0.0)
    end

    it 'statistcs#calculate_rate_very_big_loans is correct adding a 15M loan and a 20M one' do
      borrower = FactoryGirl.create(:borrower)
      in_one_week = Date.today+1.week
      three_weeks_ago = Date.today-3.week
      @current_loan_added= FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: three_weeks_ago, contractual_end_date: in_one_week,
                                              amount: 15000000, rate: 1, loan_goal: '@current_loan_added',
                                              loan_template_id: LoanTemplate.find_by(name: '1m5M').id)
      @current_loan_added2= FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: three_weeks_ago, contractual_end_date: in_one_week,
                                              amount: 20000000, rate: 1, loan_goal: '@current_loan_added',
                                              loan_template_id: LoanTemplate.find_by(name: '1m5M').id)

      @a_stat.calculate_rate_very_big_loans
      # calculated in %
      expect(@a_stat.figure.round(1)).to eq(83.3)
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

  describe 'We can sync Loan Steps' do
    before(:each) do
      today = Date.today
      @three_weeks_ago = today-3.week
      @in_one_week = today+1.week
      borrower = FactoryGirl.create(:borrower)
      @loan_template = FactoryGirl.create(:loan_template,amount: 500000, rate: 1, duration: 1, name: '1m500k')
      @loan = FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: @three_weeks_ago, contractual_end_date: @in_one_week,
                                 amount: 500000, rate: 1, loan_goal: 'Have some money to organize trips to make new deals',
                                 loan_template_id: @loan_template.id)
      @step_type = FactoryGirl.create(:step_type)
      @step_type2 = FactoryGirl.create(:step_type, :label => 'Lalalala')

      step_1_template = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type.id, :expected_date => nil,
                                           :is_done => false, :amount => @loan.amount, :loan_template_id => @loan_template.id,
                                           :days_after_previous_milestone => nil, :months_after_previous_milestone => 0)
      step_2_template = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type2.id, :expected_date => nil,
                                           :is_done => false, :amount => 505000, :loan_template_id => @loan_template.id,
                                           :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      @loan.generate_steps
      @step_1_loan = Step.new(:loan_id => @loan.id, :step_type_id => @step_type.id, :expected_date => @three_weeks_ago,
                              :is_done => false, :amount => @loan.amount, :loan_template_id => nil)
      @step_2_loan = Step.new(:loan_id => @loan.id, :step_type_id => @step_type2.id, :expected_date => @in_one_week,
                              :is_done => false, :amount => 505000, :loan_template_id => nil)
      @loan.reload
      @steps_g = @loan.steps.to_a
      @step_1 = @steps_g[0]
      @step_2 = @steps_g[1]
    end

    it 'generate_steps generated two steps from the template' do
      steps_g_count = @steps_g.count
      expect(steps_g_count).to eq(2)
    end

    it 'generate_steps generated correct amounts' do
      expect(@step_1.amount).to eq(@step_1_loan.amount)
      expect(@step_2.amount).to eq(@step_2_loan.amount)
    end

    it 'generate_steps generated correct dates' do
      expect(@step_1.expected_date).to eq(@step_1_loan.expected_date)
      expect(@step_2.expected_date).to eq(@step_2_loan.expected_date)
    end

    it 'generate_steps generated correct types' do
      expect(@step_1.step_type_id).to eq(@step_1_loan.step_type_id)
      expect(@step_2.step_type_id).to eq(@step_2_loan.step_type_id)
    end

    it 'generate_steps generated correct loan_ids' do
      expect(@step_1.loan_id).to eq(@step_1_loan.loan_id)
      expect(@step_2.loan_id).to eq(@step_2_loan.loan_id)
    end

    it 'generate_steps generated just two steps from the template even after three calls' do
      @loan.generate_steps
      @loan.reload
      @loan.generate_steps
      @loan.reload
      expect(@loan.steps.to_a.count).to eq(2)
    end

    it 'generate_steps returns the right message when there is no template linked' do
      @loan.loan_template = nil
      @loan.save
      response = @loan.generate_steps
      expect(response[:message]).to eq(I18n.t('loan.step_generation_no_t'))
    end

    it 'generate_steps returns the right message when a step is already done in the loan' do
      @step_1_loan.is_done = true
      @step_1_loan.save
      @loan.reload
      response = @loan.generate_steps
      expect(response[:message]).to eq(I18n.t('loan.step_generation_steps_already_done'))
    end

    it 'generate_steps returns the right message when all went good' do
      response = @loan.generate_steps
      expect(response[:message]).to eq(I18n.t('loan.step_generation_ok'))
    end

  end


  describe 'Loan Steps Are Synchronized' do
    before(:each) do
      today = Date.today
      @three_weeks_ago = today-3.week
      @in_one_week = today+1.week
      borrower = FactoryGirl.create(:borrower)
      @loan_template = FactoryGirl.create(:loan_template,amount: 500000, rate: 1, duration: 1, name: '1m500k')
      @loan = FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: @three_weeks_ago, contractual_end_date: @in_one_week,
                                 amount: 500000, rate: 1, loan_goal: 'Have some money to organize trips to make new deals',
                                 loan_template_id: @loan_template.id)
      @step_type = FactoryGirl.create(:step_type)
      @step_type2 = FactoryGirl.create(:step_type, :label => 'Lalalala')

      step_1_template = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type.id, :expected_date => nil,
                                          :is_done => false, :amount => @loan.amount, :loan_template_id => @loan_template.id,
                                          :days_after_previous_milestone => nil, :months_after_previous_milestone => 0)
      step_2_template = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type2.id, :expected_date => nil,
                                   :is_done => false, :amount => 505000, :loan_template_id => @loan_template.id,
                                   :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
    end

    it 'steps_synchronized? is correct when the loan does not have a template' do
      @loan.loan_template =nil
      expect(@loan.steps_synchronized?).to eq(true)
    end

    it 'steps_synchronized? is false when the loan does not have steps but the template has' do
      expect(@loan.steps_synchronized?).to eq(false)
    end



    it 'steps_synchronized? is false when the loan has one step and the template has one of each type' do
      step_1_loan = FactoryGirl.create(:step, :loan_id => @loan.id, :step_type_id => @step_type.id, :expected_date => nil,
                                           :is_done => false, :amount => @loan.amount, :loan_template_id => nil,
                                           :days_after_previous_milestone => nil, :months_after_previous_milestone => 0)
      expect(@loan.steps_synchronized?).to eq(false)
    end

    it 'steps_synchronized? is true when the loan has one step of each type and the template too' do
      step_1_loan = FactoryGirl.create(:step, :loan_id => @loan.id, :step_type_id => @step_type.id, :expected_date => nil,
                                       :is_done => false, :amount => @loan.amount, :loan_template_id => nil,
                                       :days_after_previous_milestone => nil, :months_after_previous_milestone => 0)
      step_2_loan = FactoryGirl.create(:step, :loan_id => @loan.id, :step_type_id => @step_type2.id, :expected_date => nil,
                                       :is_done => false, :amount => @loan.amount, :loan_template_id => nil,
                                       :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      expect(@loan.steps_synchronized?).to eq(true)
    end


  end



  describe 'Loan Steps: are they done or not ?' do
    before(:each) do
      today = Date.today
      three_weeks_ago = today-3.week
      in_one_week = today+1.week
      in_one_month_and_one_week = today+1.week+1.month
      in_two_months_and_one_week = today+1.week+2.month
      end_of_loan = today+1.week+3.month
      borrower = FactoryGirl.create(:borrower)
      @loan_template = FactoryGirl.create(:loan_template,amount: 500000, rate: 5, duration: 4, name: '4m500k')
      @loan = FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: three_weeks_ago, contractual_end_date: end_of_loan,
                                 amount: 500000, rate: 5, loan_goal: 'Have some money to organize trips to make new deals',
                                 loan_template_id: @loan_template.id)
      @step_type = FactoryGirl.create(:step_type)
      @step_type2 = FactoryGirl.create(:step_type, :label => 'Lalalala')

      step_1_loan = FactoryGirl.create(:step, :loan_id => @loan.id, :step_type_id => @step_type.id, :expected_date => three_weeks_ago,
                                           :is_done => false, :amount => @loan.amount, :date_done => three_weeks_ago, :is_done => true)
      step_2_loan = FactoryGirl.create(:step, :loan_id => @loan.id, :step_type_id => @step_type2.id, :expected_date => in_one_week,
                                           :is_done => false, :amount => 50000)
      step_3_loan = FactoryGirl.create(:step, :loan_id => @loan.id, :step_type_id => @step_type2.id, :expected_date => in_one_month_and_one_week,
                                       :is_done => false, :amount => 50000)
      step_4_loan = FactoryGirl.create(:step, :loan_id => @loan.id, :step_type_id => @step_type2.id, :expected_date => in_two_months_and_one_week,
                                       :is_done => false, :amount => 50000)
      step_5_loan = FactoryGirl.create(:step, :loan_id => @loan.id, :step_type_id => @step_type2.id, :expected_date => end_of_loan,
                                       :is_done => false, :amount => 355000)
    end

    it 'steps_done are just 1 here' do
      expect(@loan.steps_done.count).to eq(1)
    end

    it 'steps_not_done are just 4 here' do
      expect(@loan.steps_not_done.count).to eq(4)
    end

  end
end
