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
#  order                           :integer          default("1")
#

require 'rails_helper'

RSpec.describe Step, type: :model do

  describe 'step' do
    before(:each) do
      today = Date.today
      @three_weeks_ago = today-3.week
      in_one_week = today+1.week
      borrower = FactoryGirl.create(:borrower)
      @loan_template = FactoryGirl.create(:loan_template,amount: 500000, rate: 1, duration: 1, name: '1m500k')
      @loan = FactoryGirl.create(:loan, borrower_id: borrower.id, start_date: @three_weeks_ago, contractual_end_date: in_one_week,
                                amount: 500000, rate: 1, loan_goal: 'Have some money to organize trips to make new deals',
                                 loan_template_id: @loan_template.id)
      @step_type = FactoryGirl.create(:step_type)
      @step_second_type = FactoryGirl.create(:step_type)
      @step_done = FactoryGirl.create(:step, :loan_id => @loan.id, :step_type_id => @step_type.id, :expected_date => nil,
                                 :date_done => @three_weeks_ago, :is_done => true, :amount => @loan.amount, :loan_template_id => nil,
                                      :days_after_previous_milestone => nil, :months_after_previous_milestone => 10, :order => 1)
      @step_not_done = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type.id, :expected_date => nil,
                                          :is_done => false, :amount => @loan.amount, :loan_template_id => @loan_template.id,
                                          :days_after_previous_milestone => 15, :months_after_previous_milestone => nil)

    end

    it 'step#offset_sibling_steps_orders works when no steps after the current step' do

      @other_step = FactoryGirl.create(:step, :loan_id => @loan.id, :step_type_id => @step_second_type.id, :expected_date => nil,
                                       :date_done => @three_weeks_ago, :is_done => true, :amount => @loan.amount, :loan_template_id => nil,
                                       :days_after_previous_milestone => nil, :months_after_previous_milestone => 2, :order => 2)
      @other_step.offset_sibling_steps_orders
      @other_step.reload
      @step_done.reload
      expect(@step_done.order).to eq(1)
      expect(@other_step.order).to eq(2)
    end

    it 'step#offset_sibling_steps_orders works' do

      @other_step = FactoryGirl.create(:step, :loan_id => @loan.id, :step_type_id => @step_second_type.id, :expected_date => nil,
                                       :date_done => @three_weeks_ago, :is_done => true, :amount => @loan.amount, :loan_template_id => nil,
                                       :days_after_previous_milestone => nil, :months_after_previous_milestone => 2, :order => 2)
      @step_done.offset_sibling_steps_orders
      @other_step.reload
      @step_done.reload
      expect(@other_step.order).to eq(1)
      expect(@step_done.order).to eq(1)
    end


    it 'loan#month_number is 12 when we have 2 steps (with 0 respectively 10 and 2 months)' do

      @other_step = FactoryGirl.create(:step, :loan_id => @loan.id, :step_type_id => @step_second_type.id, :expected_date => nil,
                                      :date_done => @three_weeks_ago, :is_done => true, :amount => @loan.amount, :loan_template_id => nil,
                                      :days_after_previous_milestone => nil, :months_after_previous_milestone => 2, :order => 2)
      @other_step.previous_steps = [@step_done]
      expect(@other_step.month_number).to eq(12)
    end

    it 'loan#last_step_order should be one' do
      expect(@loan.last_step_order).to eq(1)
    end

    it 'loan#last_step_order should be 2 when we add a step' do
      @step_done = FactoryGirl.create(:step, :loan_id => @loan.id, :step_type_id => @step_second_type.id, :expected_date => nil,
                                      :date_done => @three_weeks_ago, :is_done => true, :amount => @loan.amount, :loan_template_id => nil,
                                      :days_after_previous_milestone => nil, :months_after_previous_milestone => 10)
      expect(@loan.last_step_order).to eq(2)
    end

    it 'loan_template#last_step_order should be one' do
      expect(@loan_template.last_step_order).to eq(1)
    end

    it 'step#order is 1 by default' do
      expect(@step_done.order).to eq(1)
    end

    it 'step#increment_order returns 1 when order is nil' do
      @step_done.order = nil
      @step_done.increment_order
      expect(@step_done.order).to eq(1)
    end

    it 'step#increment_order returns 2 when we increment once an order worthing 1' do
      @step_done.increment_order
      expect(@step_done.order).to eq(2)
    end

    it 'step#increment_order returns 3 when we increment twice an order worthing 1' do
      @step_done.increment_order
      @step_done.increment_order
      expect(@step_done.order).to eq(3)
    end

    it 'step#decrease_order returns 1 when order is already 1' do
      @step_done.order = 1
      @step_done.decrease_order
      expect(@step_done.order).to eq(1)
    end

    it 'step#increment_order returns 2 when we decrease once an order being 3' do
      @step_done.order = 3
      @step_done.decrease_order
      expect(@step_done.order).to eq(2)
    end

    it 'step#increment_order returns 1 when we decrease twice an order being 3' do
      @step_done.order = 3
      @step_done.decrease_order
      @step_done.decrease_order
      expect(@step_done.order).to eq(1)
    end

    it 'step#type returns Receipt when the step has the receipt type' do
      expect(@step_done.type).to eq('Release of fund')
    end

    it 'step#type returns Release of fund when the step has the release type' do
      step_type2 = FactoryGirl.create(:step_type, :label => 'Receipt')
      @step_not_done.step_type = step_type2
      expect(@step_not_done.type).to eq('Receipt')
    end

    it 'step#type returns Release of fund when the type is unknown' do
      step_type3 = FactoryGirl.create(:step_type, :label => 'aaaaa')
      @step_not_done.step_type = step_type3
      expect(@step_not_done.type).to eq('')
    end


    it 'should not be valid if there is both an expected date and a days_after_previous_milestone' do
      @step_not_done.expected_date = @three_weeks_ago
      expect(@step_not_done).to_not be_valid
    end

    it 'should have the right message when there is both an expected date and a days_after_previous_milestone' do
      @step_not_done.expected_date = @three_weeks_ago
      @step_not_done.save
      expect(@step_not_done.errors.messages[:expected_date]).to eq([I18n.t('step.not_date_and_delay_value')])
    end

    it 'should not be valid if there is both an expected date and a months_after_previous_milestone' do
      @step_done.expected_date = @three_weeks_ago
      expect(@step_done).to_not be_valid
    end

    it 'should have the right message when there is both an expected date and a months_after_previous_milestone' do
      @step_done.expected_date = @three_weeks_ago
      @step_done.save
      expect(@step_done.errors.messages[:expected_date]).to eq([I18n.t('step.not_date_and_delay_value')])
    end

    it 'should not be valid if there is no expected date and no months_after_previous_milestone and no days_after_previous' do
      @step_done.months_after_previous_milestone = nil
      expect(@step_done).to_not be_valid
    end

    it 'should have the right message when there is no expected date and no months_after_previous_milestone and no days_after_previous' do
      @step_done.months_after_previous_milestone = nil
      @step_done.save
      expect(@step_done.errors.messages[:expected_date]).to eq([I18n.t('step.at_least_date_or_delay_value')])
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

    it 'should have the right message when there no days and no months' do
      @step_not_done.days_after_previous_milestone = nil
      @step_not_done.save
      expect(@step_not_done.errors.messages[:expected_date]).to eq([I18n.t('step.at_least_date_or_delay_value')])
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

    it 'is_late? should return true when the step is late' do
      @step_not_done.expected_date = @three_weeks_ago
      expect(@step_not_done.is_late?).to eq(true)
    end

    it 'is_late? should return false when the step is already done' do
      expect(@step_done.is_late?).to eq(false)
    end

  end



end
