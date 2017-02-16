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
        unless loan_id.blank?
          my_html=render_to_string('steps/_step_for_loan', :formats => [:html], :layout => false, :locals => {:step => @new_step})
        end
        unless loan_template_id.blank?
          my_html=render_to_string('steps/_step_for_loan_template', :formats => [:html], :layout => false, :locals => {:step => @new_step})
        end
        format.json { render json: {:partial_view => my_html, :step_id => @new_step.id, :success => true} }
      else
        my_html=render_to_string('steps/_new_step', :formats => [:html], :layout => false, :locals => {:new_step => @new_step})
        format.json { render json: {:partial_view => my_html, :success => false } }
      end
    end
  end



  protected

  def permitted_params(params)
    params.permit(:loan_id, :step_type_id, :expected_date, :date_done, :amount, :loan_template_id, :days_after_previous_milestone, :months_after_previous_milestone)
  end

end
