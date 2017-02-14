# == Schema Information
#
# Table name: steps
#
#  id                              :integer          not null, primary key
#  loan_id                         :integer
#  step_type_id                    :integer
#  expected_date                   :datetime
#  date_done                       :datetime
#  is_done                         :boolean
#  amount                          :float
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  loan_template_id                :integer
#  days_after_previous_milestone   :integer
#  months_after_previous_milestone :integer
#

require 'rails_helper'

RSpec.describe Step, type: :model do

  describe 'Validation' do
    before(:each) do
      today = Date.today
      three_weeks_ago = today-3.week
      in_one_week = today+1.week
      borrower = FactoryGirl.create(:borrower)
      @loan_template = FactoryGirl.create(:loan_template,amount: 500000, rate: 1, duration: 1, name: '1m500k')
      @loan = FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: three_weeks_ago, contractual_end_date: in_one_week,
                                amount: 500000, rate: 1, loan_goal: 'Have some money to organize trips to make new deals',
                                 loan_template_id: @loan_template.id)
      @step_type = FactoryGirl.create(:step_type)
      @step_done = FactoryGirl.create(:step, :loan_id => @loan.id, :step_type_id => @step_type.id, :expected_date => three_weeks_ago,
                                 :date_done => three_weeks_ago, :is_done => true, :amount => @loan.amount, :loan_template_id => nil,
                                      :days_after_previous_milestone => nil, :months_after_previous_milestone => 10)
      @step_not_done = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type.id, :expected_date => in_one_week,
                                          :is_done => false, :amount => @loan.amount, :loan_template_id => @loan_template.id,
                                          :days_after_previous_milestone => 15, :months_after_previous_milestone => nil)

    end

    it 'should not be valid if there is both a loan AND a loan template' do
      @step_done.loan_template_id = @loan_template.id
      expect(@step_done).to_not be_valid
    end

    it 'should have the right message when there is both a loan AND a loan template' do
      @step_done.loan_template_id = @loan_template.id
      @step_done.save
      expect(@step_done.errors.messages[:loan_id]).to eq([I18n.t('step.not_loan_and_loan_template')])
    end

    it 'should not be valid if there is no loan AND no loan template' do
      @step_not_done.loan_template_id = nil
      expect(@step_not_done).to_not be_valid
    end

    it 'should have the right message when there no loan AND no loan template' do
      @step_not_done.loan_template_id = nil
      @step_not_done.save
      expect(@step_not_done.errors.messages[:loan_id]).to eq([I18n.t('step.at_least_loan_or_template')])
    end


    it 'should not be valid if there is both a number of days AND a number of months' do
      @step_done.days_after_previous_milestone = 14
      expect(@step_done).to_not be_valid
    end

    it 'should have the right message when there is both a number of days AND a number of months' do
      @step_done.days_after_previous_milestone = 14
      @step_done.save
      expect(@step_done.errors.messages[:days_after_previous_milestone]).to eq([I18n.t('step.not_days_and_months_after_prev')])
    end

    it 'should not be valid if there is no number of days nor number of months' do
      @step_not_done.days_after_previous_milestone = nil
      expect(@step_not_done).to_not be_valid
    end

    it 'should have the right message when there no loan AND no loan template' do
      @step_not_done.days_after_previous_milestone = nil
      @step_not_done.save
      expect(@step_not_done.errors.messages[:days_after_previous_milestone]).to eq([I18n.t('step.at_least_days_or_months_after_prev')])
    end


    it 'days_after_previous_milestone is a number' do
      @step_not_done.days_after_previous_milestone = 'lalala'
      expect(@step_not_done).to_not be_valid
    end

    it 'days_after_previous_milestone has the right error message when is not a number' do
      @step_not_done.days_after_previous_milestone = 'lalala'
      @step_not_done.save
      expect(@step_not_done.errors.messages[:days_after_previous_milestone]).to eq([I18n.t('error.should_be_number')])
    end

    it 'months_after_previous_milestone is a number' do
      @step_not_done.months_after_previous_milestone = 'lalala'
      expect(@step_not_done).to_not be_valid
    end

    it 'months_after_previous_milestone has the right error message when is not a number' do
      @step_not_done.months_after_previous_milestone = 'lalala'
      @step_not_done.save
      expect(@step_not_done.errors.messages[:months_after_previous_milestone]).to eq([I18n.t('error.should_be_number')])
    end



    it 'expected date should be present' do
      @step_done.expected_date = nil
      expect(@step_done).to_not be_valid
    end

    it 'amount should be present' do
      @step_done.amount = ''
      expect(@step_done).to_not be_valid
    end

    it 'is_done should always be either true or false #1' do
      @step_done.is_done = 'eeee'
      expect(@step_done.is_done).to eq(true)
    end

    it 'is_done should always be either true or false #2' do
      @step_done.is_done = false
      expect(@step_done.is_done).to eq(false)
    end


  end
end
