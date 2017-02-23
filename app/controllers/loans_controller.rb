class LoansController < ApplicationController

  def index
    @loans = Loan.includes(:borrower).natural_order.all.to_a

    # this would call the db each time
    # @past_loans = @loans.where('contractual_end_date < ?', today)
    # @current_loans = @loans.where('contractual_end_date >= ? AND start_date <= ?', today, today)
    # @future_loans = @loans.where('start_date > ?', today)

    @past_loans = @loans.select(&Loan.lambda_past)
    @current_loans = @loans.select(&Loan.lambda_current)
    @future_loans = @loans.select(&Loan.lambda_future)
  end

  def create
    permitted_params = permitted_parameters(params[:loan])
    @new_loan = Loan.new(permitted_params)
    # check the order of the last loan taken by the person
    newer_loan = Loan.where(borrower_id: @new_loan.borrower_id).order(order: :desc).first
    order_to_apply=1
    unless newer_loan.nil?
      order_to_apply = newer_loan.order + 1
    end
    @new_loan.order = order_to_apply
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
    is_sync = @loan.steps_synchronized?
    @loan.is_sync = is_sync
  end

  def show
    @loan = Loan.find_by id: params[:id]
  end

  def update
    @loan = Loan.find_by id: (params[:id])
    unless @loan.nil?
      borrower_name = @loan.borrower.full_name
      permitted_params = permitted_parameters(params[:loan])
      if @loan.update(permitted_params)
        flash[:info] = I18n.t('loan.successful_update1')+borrower_name+I18n.t('loan.successful_update2')
        redirect_to edit_loan_path(@loan)
      else
        render 'edit'
      end
    end
  end

  def destroy
    @loan = Loan.find_by id: params[:id]
    unless @loan.nil?
      @loan.destroy
      flash[:info] = I18n.t('loan.successful_deletion')
      redirect_to loans_path
    end
  end

  def borrower_for_loan
    loan_id=params[:objectid]
    @the_loan=Loan.find_by(id: loan_id)
    borrower = nil
    unless @the_loan.borrower.nil?
      borrower= @the_loan.borrower.id
    end
    respond_to do |format|
      format.json {
        render json: borrower
      }
    end
  end

  def template_for_loan
    loan_id=params[:objectid]
    @the_loan=Loan.find_by(id: loan_id)
    template = nil
    unless @the_loan.loan_template.nil?
      template= @the_loan.loan_template.id
    end
    respond_to do |format|
      format.json {
        render json: template
      }
    end
  end


  # We synchronize the steps of the loan with the steps of the loan template
  def synchronize_steps

  end

  protected

  def permitted_parameters(params)
    params.permit(:start_date, :contractual_end_date, :end_date, :is_in_default,
                  :amount, :rate, :borrower_id, :loan_goal, :order, :loan_template_id)
  end

end
