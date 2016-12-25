require 'rails_helper'

RSpec.describe 'borrowers/edit.html.erb', type: :view do
  describe 'Display correctly the page' do


    before(:each) do
      user = FactoryGirl.create(:user)
      login_as(user, :scope => :user)
      @borrower = FactoryGirl.create(:borrower)
      render
    end

    it 'renders the creation template' do
      template1='borrowers/edit'
      expect(rendered).to render_template(template1)
    end

    it 'displays correctly the form' do
      expect(rendered).to match('<form class="ui form light_form"')
    end


  end
end