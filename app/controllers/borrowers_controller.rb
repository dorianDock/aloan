class BorrowersController < ApplicationController

  def index
    @borrowers = Borrower.all
  end

  def create
    permitted_params = permitted_parameters(params[:borrower])
    borrower = Borrower.new(permitted_params)
    borrower.save!
    redirect_to borrowers_path
  end

  def new
    @new_borrower = Borrower.new
  end

  def edit

  end

  def show

  end

  def update

  end

  def destroy

  end


  protected

  def permitted_parameters(params)
    params.permit(:first_name, :project_description, :name, :birth_date, :amount_wished, :company_name)
  end


end
