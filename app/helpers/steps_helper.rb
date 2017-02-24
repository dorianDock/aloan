module StepsHelper

  def step_display_time(duration_in_months)
    if duration_in_months == 0
      t('step.initial')
    else
      t('step.time1')+duration_in_months.to_s+' '+t('month', :count => duration_in_months)
    end
  end

  def step_display_status(step)
    if step.date_done.nil?
      t('step.not_validated')
    else
      t('step.validated_on')+step.date_done.strftime('%d/%m/%Y')
    end
  end

end
