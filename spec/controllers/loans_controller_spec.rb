require 'rails_helper'



RSpec.describe LoansController, type: :controller do

  include Devise::Test::ControllerHelpers


  describe 'Anonymous must be authenticated to see one of the protected pages of loans' do
    it 'loans#index asks for authenticating' do
      get :index
      expect(response).to have_http_status(:redirect)
      # redirected to the sign in page
    end
  end

  describe 'Actions working for loans >' do

    before(:each) do
      @user= FactoryGirl.create(:user)
      sign_in @user
      @borrower_attached = FactoryGirl.create(:borrower)
      @loan = FactoryGirl.create(:loan, {:borrower_id => @borrower_attached.id})
    end

    it 'loans#index is reachable' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'loans#new is reachable' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'loans#show is reachable' do
      get :show, params: { id: @loan.id }
      expect(response).to have_http_status(:success)
    end

    it 'loans#edit is reachable' do
      get :edit, params: { id: @loan.id }
      expect(response).to have_http_status(:success)
    end


    it 'creation of a loan works' do
      loans_params = FactoryGirl.attributes_for(:loan)
      borrower = FactoryGirl.create(:borrower)
      loans_params[:borrower_id]=borrower.id
      expect { process :create, method: :post, params: { loan: loans_params }}
          .to change(Loan, :count).by(1)
    end

    it 'order is 1 when it is the first loan' do
      loans_params = FactoryGirl.attributes_for(:loan)
      borrower = FactoryGirl.create(:borrower)
      loans_params[:borrower_id]=borrower.id
      process :create, method: :post, params: { loan: loans_params }
      loan_created = Loan.last
      expect(loan_created.order).to eq(1)
    end

    it 'order is 2 when it is the second loan' do
      loans_params = FactoryGirl.attributes_for(:loan)
      borrower = FactoryGirl.create(:borrower)
      loans_params[:borrower_id]=borrower.id
      process :create, method: :post, params: { loan: loans_params }
      process :create, method: :post, params: { loan: loans_params }
      loan_created = Loan.last
      expect(loan_created.order).to eq(2)
    end

    it 'order is 6 when it is the sixth loan' do
      loans_params = FactoryGirl.attributes_for(:loan)
      borrower = FactoryGirl.create(:borrower)
      loans_params[:borrower_id]=borrower.id

      6.times do
        process :create, method: :post, params: { loan: loans_params }
      end

      loan_created = Loan.last
      expect(loan_created.order).to eq(6)
    end


  end


  describe 'Actions failing for borrowers >' do
    before(:each) do
      @user= FactoryGirl.create(:user)
      sign_in @user
      @borrower_attached = FactoryGirl.create(:borrower)
      @loan = FactoryGirl.create(:loan, {:borrower_id => @borrower_attached.id})
    end

    it 'creation fails when no borrower is provided or no rate or no amount or no start_date' do
      loans_params = {borrower_id: nil, rate: nil, amount: nil, start_date: nil}
      expect { process :create, method: :post, params: { loan: loans_params }}
          .to change(Loan, :count).by(0)
    end



  end
end
