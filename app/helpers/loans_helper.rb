module LoansHelper

  # allow to select the good translation of the order based on the name of a translation
  # ex: a count of 1 will call times.one
  # you can then call it with t(ordinalize_with_language(count))
  def ordinalize_with_language(count)
    translation_to_call='times.'
    case count
      when count == 1
        translation_to_call+='one'
      when count == 2
        translation_to_call+='two'
      when count == 3
        translation_to_call+='three'
      else
        translation_to_call+='other'
    end
    translation_to_call
  end
end
