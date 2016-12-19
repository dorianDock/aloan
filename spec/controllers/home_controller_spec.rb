require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  include Devise::Test::ControllerHelpers

  describe 'Anonymous must be authenticated to see one of the protected pages' do
    it 'home#index asks for authenticating' do
      get :index
      expect(response).to have_http_status(:redirect)
      # redirected to the sign in page
    end
  end

  describe 'Authenticating user for home' do

    before(:each) do
      @user= FactoryGirl.create(:user)
      sign_in @user
    end

    it 'Home#index is reachable' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'Home#secured is reachable' do
      get :secured
      expect(response).to have_http_status(:success)
    end
  end

end
