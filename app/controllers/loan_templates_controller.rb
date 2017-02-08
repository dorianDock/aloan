class LoanTemplatesController < ApplicationController

  def index
    @templates = LoanTemplate.all.amount_order
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

  def destroy_by_popup
    loan_template_id = params[:objectid]
    loan_template = LoanTemplate.find_by(id: loan_template_id)
    response_message=''
    name=''
    is_destroyed=false
    unless loan_template.nil?
      name = loan_template.name
      # find all templates where this template was a prerequisite, and break the link
      following_templates = LoanTemplate.where(:template_completed_before_id => loan_template_id)
      following_templates.each do |template|
        template.template_completed_before_id = nil
        template.save
      end
      loan_template.destroy
      is_destroyed = loan_template.destroyed?
      if (is_destroyed)
        response_message = name+I18n.t('successful_deletion')
      else
        response_message = I18n.t('error_deletion')
      end
    end
    flash[:info] = response_message
    respond_to do |format|
      format.json {
        render json: {:isError => !(is_destroyed), :responseMessage => response_message, :redirection => loan_templates_path}
      }
    end
  end

  def prerequisite_for_template
    template_id=params[:objectid]
    @the_template=LoanTemplate.find_by(id: template_id)
    prerequisite = nil
    unless @the_template.prerequisite.nil?
      prerequisite= @the_template.prerequisite.id
    end
    respond_to do |format|
      format.json {
        render json: prerequisite
      }
    end
  end

  def json_for_template
    template_id=params[:objectid]
    @the_template=LoanTemplate.find_by(id: template_id)
    respond_to do |format|
      format.json {
        render json: @the_template
      }
    end
  end



  protected

  def permitted_parameters(params)
    params.permit(:amount, :rate, :duration, :name, :template_completed_before_id)
  end


end
