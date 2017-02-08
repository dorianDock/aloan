require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the LoansHelper. For example:
#
# describe LoansHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe LoansHelper, type: :helper do
  describe 'ordinalize_with_language' do

    it 'returns 1st when the count is 1' do
      translation_to_call = ordinalize_with_language(1)
      expect(t(translation_to_call)).to eq('st')
    end
    it 'returns 2nd when the count is 2' do
      translation_to_call = ordinalize_with_language(2)
      expect(t(translation_to_call)).to eq('nd')
    end
    it 'returns 3rd when the count is 3' do
      translation_to_call = ordinalize_with_language(3)
      expect(t(translation_to_call)).to eq('rd')
    end

    it 'returns 6th when the count is 6' do
      translation_to_call = ordinalize_with_language(6)
      expect(t(translation_to_call)).to eq('th')
    end

  end


  describe 'loan_title' do
    before(:each) do

    end
    it 'returns correct title' do
      a_borrower= FactoryGirl.create(:borrower)
      a_loan = FactoryGirl.create(:loan, {:borrower_id => a_borrower.id})
      title = loan_title(a_loan)
      expect(title).to match('10th loan taken by')
    end

    it 'returns correct light title' do
      a_borrower= FactoryGirl.create(:borrower)
      a_loan = FactoryGirl.create(:loan, {:borrower_id => a_borrower.id})
      title = light_loan_title(a_loan)
      expect(title).to match('<i></i>10th loan taken by <span>John Borrows</span>')
    end



  end

  describe 'compare_with_today' do
    it 'returns 1 day ago when the number is -1' do
      text = compare_with_today(-1)
      expect(text).to eq('1 days ago.')
    end
    it 'returns in 1 day when the number is 1' do
      text = compare_with_today(1)
      expect(text).to eq('in 1 days.')
    end
    it 'returns today when the number is 0' do
      text = compare_with_today(0)
      expect(text).to eq('today.')
    end
    it 'returns 65 days ago when the number is -65' do
      text = compare_with_today(-65)
      expect(text).to eq('65 days ago.')
    end
    it 'returns in 25 day when the number is 25' do
      text = compare_with_today(25)
      expect(text).to eq('in 25 days.')
    end
  end

  describe 'Display month duration' do
    it 'displays 3 months for 3' do
      expect(display_month_duration(3)).to eq('3 months.')
    end
    it 'displays < 1 month for 0' do
      expect(display_month_duration(0)).to eq('< 1 month.')
    end
  end


end
