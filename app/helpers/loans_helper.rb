module LoansHelper

  # allow to select the good translation of the order based on the name of a translation
  # ex: a count of 1 will call times.one
  # you can then call it with t(ordinalize_with_language(count))
  def ordinalize_with_language(count)
    translation_to_call='times.'
    case count
      when 1
        translation_to_call+='one'
      when 2
        translation_to_call+='two'
      when 3
        translation_to_call+='three'
      else
        translation_to_call+='other'
    end
    translation_to_call
  end


  def loan_title(loan)
    content_tag(:i)+loan.order.to_s+t(ordinalize_with_language(loan.order))+t('loan.loan_of')+
    content_tag(:a, loan.borrower.full_name, :href => borrower_path(loan.borrower)).html_safe
  end



  def compare_with_today(day_number)
    if day_number > 0
      result = t('future_days', :number => day_number)
    elsif day_number == 0
      result = t('today')
    else
      day_number=(-day_number)
      result = t('ago_days', :number => day_number)
    end
    result
  end


end
