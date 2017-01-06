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
end
