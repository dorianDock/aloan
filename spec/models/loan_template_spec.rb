# == Schema Information
#
# Table name: loan_templates
#
#  id                           :integer          not null, primary key
#  amount                       :float
#  rate                         :float
#  duration                     :integer
#  name                         :string
#  template_completed_before_id :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#

require 'rails_helper'

RSpec.describe LoanTemplate, type: :model do
  describe 'Validation' do
    before(:each) do
      @loan_template = FactoryGirl.create(:loan_template)
    end

    it 'should be valid with an amount, a rate, a duration, and a name' do
      expect(@loan_template).to be_valid
    end

    it 'should not be valid if the amount is missing' do
      @loan_template.amount=nil
      expect(@loan_template).to_not be_valid
    end

    it 'should not be valid if the rate is missing' do
      @loan_template.rate=nil
      expect(@loan_template).to_not be_valid
    end

    it 'should not be valid if the duration is missing' do
      @loan_template.duration=nil
      expect(@loan_template).to_not be_valid
    end

    it 'should not be valid if the name is missing' do
      @loan_template.name=nil
      expect(@loan_template).to_not be_valid
    end
  end

  describe 'Interactions' do
    it 'has_many loans' do
      association=described_class.reflect_on_association(:loans)
      expect(association.macro).to eq :has_many
    end
    it 'has_many following_loan_templates' do
      association=described_class.reflect_on_association(:following_loan_templates)
      expect(association.macro).to eq :has_many
    end
    it 'belongs_to prerequisite' do
      association=described_class.reflect_on_association(:prerequisite)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'Methods' do
    before(:each) do
      @loan_template = FactoryGirl.create(:loan_template)
    end
    it 'shows a prerequisite name when there is a prerequisite' do
      loan_template_2 = FactoryGirl.create(:loan_template, :template_completed_before_id => @loan_template.id)
      expect(loan_template_2.prerequisite_name).to eq('MyLoanProduct')
    end

    it 'shows an empty name when there is not a prerequisite' do
      loan_template_2 = FactoryGirl.create(:loan_template)
      expect(loan_template_2.prerequisite_name).to eq(nil)
    end
  end

  describe 'Interactions with steps' do
    before(:each) do
      @loan_template = FactoryGirl.create(:loan_template, :amount => 1000000, :rate => 5, :duration => 4)
      @step_type_receipt = FactoryGirl.create(:step_type, :label => 'Receipt')
      @step_type_release = FactoryGirl.create(:step_type)

      # @step1 = FactoryGirl.create(:step, :step_type_id => @step_type_release.id, :expected_date => nil, :is_done => false,
      #                             :amount => 1000000, :loan_template_id => @loan_template.id,
      #                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 0)
      # @step2 = FactoryGirl.create(:step, :step_type_id => @step_type_receipt.id, :expected_date => nil, :is_done => false,
      #                             :amount => 200000, :loan_template_id => @loan_template.id,
      #                             :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      # @step3 = FactoryGirl.create(:step, :step_type_id => @step_type_receipt.id, :expected_date => nil, :is_done => false,
      #                             :amount => 200000, :loan_template_id => @loan_template.id,
      #                             :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      # @step4 = FactoryGirl.create(:step, :step_type_id => @step_type_receipt.id, :expected_date => nil, :is_done => false,
      #                             :amount => 200000, :loan_template_id => @loan_template.id,
      #                             :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      # @step5 = FactoryGirl.create(:step, :step_type_id => @step_type_receipt.id, :expected_date => nil, :is_done => false,
      #                             :amount => 410000, :loan_template_id => @loan_template.id,
      #                             :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)


    end

    it 'when no steps, maximum amount of release is the amount of the loan' do
      expect(@loan_template.maximum_release_amount).to eq(1000000)
    end

    it 'when no steps, maximum amount of receipt is 0 (no release yet)' do
      expect(@loan_template.maximum_receipt_amount).to eq(0)
    end

    it 'when one initial step with the full amount of the loan, maximum amount of release is 0' do

      step1 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_release.id, :expected_date => nil, :is_done => false,
                                  :amount => 1000000, :loan_template_id => @loan_template.id,
                                      :days_after_previous_milestone => nil, :months_after_previous_milestone => 0)
      expect(@loan_template.maximum_release_amount).to eq(0)
    end

    it 'when one initial step with the full amount of the loan, maximum amount of receipt is the amount + the interests' do
      step1 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_release.id, :expected_date => nil, :is_done => false,
                                 :amount => 1000000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 0)
      expect(@loan_template.maximum_receipt_amount).to eq(1050000)
    end

    it 'when one initial step with a partial amount of the loan, maximum amount of release is the total amount - this partial amount' do
      step1 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_release.id, :expected_date => nil, :is_done => false,
                                 :amount => 400000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 0)
      expect(@loan_template.maximum_release_amount).to eq(600000)
    end

    it 'when one initial step with a partial amount of the loan, maximum amount of receipt is this partial amount + the interests on it' do
      step1 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_release.id, :expected_date => nil, :is_done => false,
                                 :amount => 100000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 0)
      expect(@loan_template.maximum_receipt_amount).to eq(105000)
    end

    it 'when one step of release and one step of receipt, max receipt amount is correct' do
      step1 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_release.id, :expected_date => nil, :is_done => false,
                                 :amount => 1000000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 0)
      step2 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_receipt.id, :expected_date => nil, :is_done => false,
                                  :amount => 200000, :loan_template_id => @loan_template.id,
                                  :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      expect(@loan_template.maximum_receipt_amount).to eq(850000)

    end

    it 'when there is just on step of receipt missing, max receipt amount is correct' do
      step1 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_release.id, :expected_date => nil, :is_done => false,
                                 :amount => 1000000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 0)
      step2 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_receipt.id, :expected_date => nil, :is_done => false,
                                 :amount => 200000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      step3 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_receipt.id, :expected_date => nil, :is_done => false,
                                 :amount => 200000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      step4 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_receipt.id, :expected_date => nil, :is_done => false,
                                 :amount => 200000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      expect(@loan_template.maximum_receipt_amount).to eq(450000)
    end

    it 'when there is just a last step to have for interests, max receipt amount is correct' do
      step1 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_release.id, :expected_date => nil, :is_done => false,
                                 :amount => 1000000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 0)
      step2 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_receipt.id, :expected_date => nil, :is_done => false,
                                 :amount => 200000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      step3 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_receipt.id, :expected_date => nil, :is_done => false,
                                 :amount => 200000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      step4 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_receipt.id, :expected_date => nil, :is_done => false,
                                 :amount => 200000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      step5 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_receipt.id, :expected_date => nil, :is_done => false,
                                 :amount => 400000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      expect(@loan_template.maximum_receipt_amount).to eq(50000)
    end

    it 'when each step is done, max receipt amount is correct' do
      step1 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_release.id, :expected_date => nil, :is_done => false,
                                 :amount => 1000000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 0)
      step2 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_receipt.id, :expected_date => nil, :is_done => false,
                                 :amount => 200000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      step3 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_receipt.id, :expected_date => nil, :is_done => false,
                                 :amount => 200000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      step4 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_receipt.id, :expected_date => nil, :is_done => false,
                                 :amount => 200000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      step5 = FactoryGirl.create(:step, :loan_id => nil, :step_type_id => @step_type_receipt.id, :expected_date => nil, :is_done => false,
                                 :amount => 450000, :loan_template_id => @loan_template.id,
                                 :days_after_previous_milestone => nil, :months_after_previous_milestone => 1)
      expect(@loan_template.maximum_receipt_amount).to eq(0)
    end



  end


  describe 'Scopes' do
    before(:each) do
      @loan_template1 = FactoryGirl.create(:loan_template, :amount => 100000)
      @loan_template2 = FactoryGirl.create(:loan_template, :amount => 200000)
      @loan_template3 = FactoryGirl.create(:loan_template, :amount => 300000)
      @loan_template4 = FactoryGirl.create(:loan_template, :amount => 400000)
      @loan_template5 = FactoryGirl.create(:loan_template, :amount => 500000)
      @loan_template6 = FactoryGirl.create(:loan_template, :amount => 600000)
      @loan_template7 = FactoryGirl.create(:loan_template, :amount => 700000)
    end

    it 'should be ordered via amount asc when amount_order' do
      expect(LoanTemplate.amount_order.count).to eq(7)
      expect(LoanTemplate.amount_order.first).to eq(@loan_template1)
      expect(LoanTemplate.amount_order.second).to eq(@loan_template2)
      expect(LoanTemplate.amount_order.last).to eq(@loan_template7)
    end


  end
end
