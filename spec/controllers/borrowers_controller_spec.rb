require 'rails_helper'

RSpec.describe BorrowersController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'Anonymous must be authenticated to see one of the protected pages' do
    it 'borrowers#index asks for authenticating' do
      get :index
      expect(response).to have_http_status(:redirect)
      # redirected to the sign in page
    end
  end

  describe 'Authenticating user for borrowers' do

    before(:each) do
      @user= FactoryGirl.create(:user)
      sign_in @user
    end

    it 'borrowers#index is reachable' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'borrowers#new is reachable' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
end
