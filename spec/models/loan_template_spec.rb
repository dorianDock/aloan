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
