class LoansController < ApplicationController

  def index
    @loans = Loan.natural_order.all
  end

  def create
    permitted_params = permitted_parameters(params[:loan])
    @new_loan = Loan.new(permitted_params)
    if @new_loan.valid?
      @new_loan.save!
      redirect_to loans_path
    else
      render 'new'
    end
  end

  def new
    @new_loan = Loan.new
  end

  def edit
    @loan = Loan.find_by id: params[:id]
  end

  def show
    @loan = Loan.find_by id: params[:id]
  end

  def update
    @loan = Loan.find_by id: (params[:loan][:id])
    unless @loan.nil?
      borrower_name = @loan.borrower.full_name
      permitted_params = permitted_parameters(params[:loan])
      @loan.update(permitted_params)
      flash[:info] = I18n.t('loan.successful_update1')+borrower_name+I18n.t('loan.successful_update2')
    end
    redirect_to edit_loan_path
  end

  def destroy
    @loan = Loan.find_by id: params[:id]
    unless @loan.nil?
      @loan.destroy
      flash[:info] = I18n.t('loan.successful_deletion')
      redirect_to loans_path
    end
  end

  protected

  def permitted_parameters(params)
    params.permit(:start_date, :contractual_end_date, :end_date, :is_in_default, :amount, :rate, :borrower_id, :loan_goal)
  end

end
