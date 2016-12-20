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
    @borrower = Borrower.find_by id: params[:id]
  end

  def show

  end

  def update
    @borrower = Borrower.find_by id: (params[:borrower][:id])
    unless @borrower.nil?
      borrower_name = @borrower.full_name
      permitted_params = permitted_parameters(params[:borrower])
      @borrower.update(permitted_params)

      flash[:info] = borrower_name+I18n.t('successful_update')
    end
    redirect_to edit_borrower_path
  end

  def destroy
    @borrower = Borrower.find_by id: params[:id]
    borrower_name = @borrower.full_name
    unless @borrower.nil?
      @borrower.destroy
      flash[:info] = borrower_name+I18n.t('successful_deletion')
      redirect_to borrowers_path
    end
  end

  def destroy_by_popup
    borrower_id = params[:objectid]
    borrower = Borrower.find_by(id: borrower_id)
    borrower_name = ''
    unless borrower.nil?
      borrower_name = borrower.full_name
      borrower.destroy
    end
    response_message=''
    if (borrower.destroyed?)
      response_message = borrower_name+I18n.t('successful_deletion')
    else
      response_message=I18n.t('error_deletion')
    end

    flash[:info] = response_message
    respond_to do |format|
      format.json {
        render json: {:isError => !(borrower.destroyed?), :responseMessage => response_message, :redirection => borrowers_path }
      }
    end
  end



  protected

  def permitted_parameters(params)
    params.permit(:first_name, :project_description, :name, :birth_date, :amount_wished, :company_name)
  end


end
