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

  describe 'Actions working for borrowers' do

    before(:each) do
      @user= FactoryGirl.create(:user)
      sign_in @user
      @borrower = FactoryGirl.create(:borrower)
    end

    it 'borrowers#index is reachable' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'borrowers#new is reachable' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'borrowers#edit is reachable' do
      get :edit, params: { id: @borrower.id }
      expect(response).to have_http_status(:success)
    end

    it 'borrowers#show is reachable' do
      get :show, params: { id: @borrower.id }
      expect(response).to have_http_status(:success)
    end


    it 'creation of a borrower works' do
      # request.accept = "application/json"
      borrowers_params = FactoryGirl.attributes_for(:borrower)
      expect { process :create, method: :post, params: { borrower: borrowers_params }}
          .to change(Borrower, :count).by(1)
    end

    it 'edition of a borrower works' do
      borrowers_params = FactoryGirl.attributes_for(:borrower)
      borrowers_params[:id] = @borrower.id
      borrowers_params[:name] = 'Bibou'
      process :update, method: :patch, params: { id: @borrower.id, borrower: borrowers_params }
      @borrower.reload
      expect(@borrower.name).to eq('Bibou')
    end

    it 'deletion of a borrower works' do
      get :destroy_by_popup, params: {id: @borrower.id, objectid: @borrower.id}, format: :json
      json_body= JSON.parse(response.body)
      expect(json_body).to include('isError' => false)
    end
  end


  describe 'Actions failing for borrowers' do
    before(:each) do
      @user= FactoryGirl.create(:user)
      sign_in @user
      @borrower = FactoryGirl.create(:borrower)
    end

    it 'creation fails when object is empty' do
      borrowers_params = {name: '', first_name: ''}
      expect { process :create, method: :post, params: { borrower: borrowers_params }}
          .to change(Borrower, :count).by(0)
    end

    it 'edition fails when we dont provide a name' do
      borrowers_params = {}
      borrowers_params[:id] = @borrower.id
      process :update, method: :patch, params: { id: @borrower.id, borrower: borrowers_params }
      @borrower.reload
      expect(@borrower.name).to eq('Borrows')
    end


    it 'deletion fails when the wrong id is provided' do
      get :destroy_by_popup, params: {id: 555555, objectid: 555555}, format: :json
      json_body= JSON.parse(response.body)
      expect(json_body).to include('isError' => true)
    end

  end




end
