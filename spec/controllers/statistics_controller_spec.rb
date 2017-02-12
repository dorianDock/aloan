require 'rails_helper'

RSpec.describe StatisticsController, type: :controller do

  include Devise::Test::ControllerHelpers


  describe 'Anonymous must be authenticated to see one of the protected pages of statistics' do
    it 'statistics#index asks for authenticating' do
      get :index
      expect(response).to have_http_status(:redirect)
      # redirected to the sign in page
    end
  end

  describe 'Actions working for loans >' do
    before(:each) do
      @user= FactoryGirl.create(:user)
      sign_in @user
    end
    it 'statistics#index is reachable' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
