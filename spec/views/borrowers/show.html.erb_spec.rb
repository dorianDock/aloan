require 'rails_helper'

RSpec.describe 'borrowers/show.html.erb', type: :view do
  describe 'Display correctly the page' do


    before(:each) do
      user = FactoryGirl.create(:user)
      login_as(user, :scope => :user)
      @borrower = FactoryGirl.create(:borrower)
      render
    end

    it 'renders the show template' do
      template1='borrowers/show'
      expect(rendered).to render_template(template1)
    end

    it 'displays correctly the first section' do
      expect(rendered).to match('<span class="ui header">Account Summary')
    end


  end
end