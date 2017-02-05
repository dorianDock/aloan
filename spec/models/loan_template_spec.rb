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
end
