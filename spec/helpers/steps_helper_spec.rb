require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the StepsHelper. For example:
#
# describe StepsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe StepsHelper, type: :helper do
  describe 'step_display_time(duration_in_months)' do

    it 'returns initial step when the duration is 0 month' do
      result = step_display_time(0)
      expect(result).to eq(t('step.initial'))
    end

    it 'is correct when the duration is 1 month' do
      result = step_display_time(1)
      expect(result).to eq('After 1 month')
    end

    it 'is correct when the duration is 2 months' do
      result = step_display_time(2)
      expect(result).to eq('After 2 months')
    end

    it 'step_display_status displays a correct message when the step is not done' do
      a_step = Step.new
      a_step.date_done = nil
      result = step_display_status(a_step)
      expect(result).to eq(t('step.not_validated'))
    end

    it 'step_display_status displays a correct message when the step is done' do
      a_step = Step.new
      a_step.date_done = Date.today
      result = step_display_status(a_step)
      expect(result).to eq(t('step.validated_on')+a_step.date_done.strftime('%d/%m/%Y'))
    end

  end

end
