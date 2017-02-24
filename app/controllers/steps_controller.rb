class StepsController < ApplicationController


  def new
    loan_id = params[:loan_id]
    loan_template_id = params[:loan_template_id]
    
    @new_step = Step.new
    if loan_id
      @new_step.loan_id = loan_id
    elsif loan_template_id
      @new_step.loan_template_id = loan_template_id
    end

    my_html=render_to_string('steps/_new_step', :formats => [:html], :layout => false, :locals => {})

    respond_to do |format|
      format.json {
        render json: {:partial_view => my_html }
      }
    end
  end

  # we have one create action for two cases: whether it is a loan or a loan template
  def create
    permitted_params = permitted_params(params[:step])
    @new_step = Step.new(permitted_params)
    @new_step.is_done = false
    respond_to do |format|
      if @new_step.valid?
        @new_step.save!
        loan_id = permitted_params[:loan_id]
        loan_template_id = permitted_params[:loan_template_id]
        my_html = ''
        max_release_amount = 0
        max_receipt_amount = 0
        unless loan_id.blank?
          my_html=render_to_string('steps/_step_for_loan', :formats => [:html], :layout => false, :locals => {:step => @new_step})
        end
        unless loan_template_id.blank?
          my_html=render_to_string('steps/_step_for_loan_template', :formats => [:html], :layout => false, :locals => {:step => @new_step})
          loan_template = LoanTemplate.find_by(:id => loan_template_id)
          max_release_amount = loan_template.maximum_release_amount
          max_receipt_amount = loan_template.maximum_receipt_amount
        end
        format.json { render json: {:partial_view => my_html, :step_id => @new_step.id,
                                    :max_release_amount => max_release_amount, :max_receipt_amount => max_receipt_amount, :success => true} }
      else
        my_html=render_to_string('steps/_new_step', :formats => [:html], :layout => false, :locals => {:new_step => @new_step})
        format.json { render json: {:partial_view => my_html, :success => false } }
      end
    end
  end

  def edit
    @step = Step.find_by id: params[:id]
    template = @step.loan_template
    @max_release_amount = template.maximum_release_amount
    @max_receipt_amount = template.maximum_receipt_amount
  end

  def update
    @step = Step.find_by id: params[:id]
    unless @step.nil?
      permitted_params = permitted_params(params[:step])
      if @step.update(permitted_params)
        flash[:info] = I18n.t('step.successful_update')
        # According to what the step is linked to, we redirect to a different page
        unless @step.loan_id.nil?
          redirect_to edit_loan_path(@step.loan)
        end
        unless @step.loan_template_id.nil?
          redirect_to edit_loan_template_path(@step.loan_template)
        end
      else
        render 'edit'
      end
    end

  end



  def destroy_by_popup
    parent_id = params[:parent_id] || 0
    parent_type = params[:parent_type]
    if parent_type=='Loan'
      redirection_path = loan_path(parent_id)
    end
    if parent_type=='LoanTemplate'
      redirection_path = edit_loan_template_path(parent_id)
    end
    step = Step.find_by(id: params[:objectid])
    response_message=''
    is_destroyed=false
    unless step.nil?
      step.destroy
      is_destroyed = step.destroyed?
      if is_destroyed
        response_message = I18n.t('step.class_article_name')+I18n.t('successful_deletion')
        flash[:info] = response_message
      else
        response_message=I18n.t('error_deletion')
        flash[:alert] = response_message
      end
    end

    respond_to do |format|
      format.json {
        render json: {:isError => !(is_destroyed), :redirection => redirection_path}
      }
    end
  end

  # def type_for_step
  #   step_id=params[:objectid]
  #   @the_step=Step.find_by(id: loan_id)
  #   template = nil
  #   unless @the_loan.loan_template.nil?
  #     template= @the_loan.loan_template.id
  #   end
  #   respond_to do |format|
  #     format.json {
  #       render json: template
  #     }
  #   end
  # end


  protected

  def permitted_params(params)
    params.permit(:loan_id, :step_type_id, :expected_date, :date_done, :amount, :loan_template_id, :days_after_previous_milestone, :months_after_previous_milestone)
  end

end
