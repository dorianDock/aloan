require 'rails_helper'

RSpec.describe 'borrowers/new.html.erb', type: :view do
  describe 'Display correctly the page' do


    before(:each) do
      user = FactoryGirl.create(:user)
      login_as(user, :scope => :user)
      @new_borrower = Borrower.new
      render
    end

    it 'renders the creation template' do
      template1='borrowers/new'
      expect(rendered).to render_template(template1)
    end

    it 'displays correctly the form' do
      expect(rendered).to match('<form class="ui form light_form"')
    end

    it 'displays correctly the title' do
      expect(rendered).to match('<h1>Create new borrower</h1>')
    end


  end
end
