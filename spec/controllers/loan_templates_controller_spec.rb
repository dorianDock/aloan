require 'rails_helper'

RSpec.describe LoanTemplatesController, type: :controller do
  include Devise::Test::ControllerHelpers


  describe 'Anonymous must be authenticated to see one of the protected pages of loan templates' do
    it 'loan_templates#index asks for authenticating' do
      get :index
      expect(response).to have_http_status(:redirect)
      # redirected to the sign in page
    end
  end

  describe 'Get Actions are reachable for loan_templates >' do
    before(:each) do
      @user= FactoryGirl.create(:user)
      sign_in @user
      @loan_template = FactoryGirl.create(:loan_template)
    end

    it 'loan_templates#index is reachable' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'loan_templates#new is reachable' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'loan_templates#edit is reachable' do
      get :edit, params: { id: @loan_template.id }
      expect(response).to have_http_status(:success)
    end

    it 'loan_templates#prerequisite_for_template is reachable' do
      get :prerequisite_for_template, params: { id: @loan_template.id , objectid: @loan_template.id }, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'loan_templates#prerequisite_for_template works when we updated the template before' do
      loan_template2 = FactoryGirl.create(:loan_template,{:template_completed_before_id => @loan_template.id})
      get :prerequisite_for_template, params: { id: loan_template2.id , objectid: loan_template2.id }, format: :json
      expect(response.body).to eq(@loan_template.id.to_s)
    end

    it 'loan_templates#json_for_template works' do
      get :json_for_template, params: { objectid: @loan_template.id }, format: :json
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['name']).to eq(@loan_template.name)
    end

  end

  describe 'Post and Patch Actions are working for loan_templates >' do
    before(:each) do
      @user= FactoryGirl.create(:user)
      sign_in @user
      @loan_template = FactoryGirl.create(:loan_template)
    end

    it 'creation of a loan template works' do
      loan_templates_params = FactoryGirl.attributes_for(:loan_template)
      expect { process :create, method: :post, params: { loan_template: loan_templates_params }}
          .to change(LoanTemplate, :count).by(1)
    end

    it 'edition of a loan template works when we change the name' do
      loan_templates_params = FactoryGirl.attributes_for(:loan_template)
      loan_templates_params[:id] = @loan_template.id
      loan_templates_params[:name] = 'Bralala'
      process :update, method: :patch, params: { id: @loan_template.id, loan_template: loan_templates_params }
      @loan_template.reload
      expect(@loan_template.name).to eq('Bralala')
    end

    it 'edition of a loan template works when we change the prerequisite' do
      loan_templates_params = FactoryGirl.attributes_for(:loan_template)
      loan_templates_params[:id] = @loan_template.id
      loan_template2 = FactoryGirl.create(:loan_template)
      loan_templates_params[:template_completed_before_id] = loan_template2.id
      process :update, method: :patch, params: { id: @loan_template.id, loan_template: loan_templates_params }
      @loan_template.reload
      expect(@loan_template.template_completed_before_id).to eq(loan_template2.id)
    end

    it 'edition of a loan template works when we remove the prerequisite' do
      loan_templates_params = FactoryGirl.attributes_for(:loan_template)
      loan_templates_params[:id] = @loan_template.id
      loan_template2 = FactoryGirl.create(:loan_template)
      loan_templates_params[:template_completed_before_id] = loan_template2.id
      process :update, method: :patch, params: { id: @loan_template.id, loan_template: loan_templates_params }
      loan_templates_params[:template_completed_before_id] = nil
      process :update, method: :patch, params: { id: @loan_template.id, loan_template: loan_templates_params }
      @loan_template.reload
      expect(@loan_template.template_completed_before_id).to eq(nil)
    end

    it 'deletion of a loan template works' do
      get :destroy_by_popup, params: {id: @loan_template.id, objectid: @loan_template.id}, format: :json
      json_body= JSON.parse(response.body)
      expect(json_body).to include('isError' => false)
    end

  end

  describe 'Failing cases for loan_templates >' do
    before(:each) do
      @user= FactoryGirl.create(:user)
      sign_in @user
      @loan_template = FactoryGirl.create(:loan_template)
    end

    it 'creation fails when no rate is provided or no amount' do
      loan_templates_params = {rate: nil, amount: nil}
      expect {process :create, method: :post, params: { loan_template: loan_templates_params }}
          .to change(LoanTemplate, :count).by(0)
    end

    it 'edition fails when no rate is provided or no amount' do
      loan_templates_params = {rate: nil, amount: nil}
      expect {process :update, method: :patch, params: { id: @loan_template.id, loan_template: loan_templates_params }}
          .to change(LoanTemplate, :count).by(0)
    end

    it 'deletion returns an error when no id is provided' do
      get :destroy_by_popup, params: {id: 555555, objectid: 555555}, format: :json
      json_body= JSON.parse(response.body)
      expect(json_body).to include('isError' => true)
    end


  end

end
