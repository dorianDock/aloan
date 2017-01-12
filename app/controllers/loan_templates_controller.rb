class LoanTemplatesController < ApplicationController

  def index
    @templates = LoanTemplate.all
  end

  def create
    permitted_params = permitted_parameters(params[:loan_template])
    @new_loan_template = LoanTemplate.new(permitted_params)

    if @new_loan_template.valid?
      @new_loan_template.save!
      redirect_to loan_templates_path
    else
      render 'new'
    end
  end

  def new
    @new_loan_template = LoanTemplate.new
  end

  def edit
    @template = LoanTemplate.find_by id: params[:id]
  end

  def show
    @template = LoanTemplate.find_by id: params[:id]
  end

  def update
    @template = LoanTemplate.find_by id: (params[:loan_template][:id])
    unless @template.nil?
      permitted_params = permitted_parameters(params[:loan_template])
      @template.update(permitted_params)
      flash[:info] = I18n.t('loan_template.successful_update1')+@template.name+I18n.t('loan_template.successful_update2')
    end
    redirect_to edit_loan_template_path
  end

  def destroy
    @template = LoanTemplate.find_by id: params[:id]
    unless @template.nil?
      @template.destroy
      flash[:info] = I18n.t('loan_template.successful_deletion')
      redirect_to loan_templates_path
    end
  end

  protected

  def permitted_parameters(params)
    params.permit(:amount, :rate, :duration, :name, :template_completed_before_id)
  end


end
