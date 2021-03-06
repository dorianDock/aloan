class StatisticsController < ApplicationController

  def index
    @stats = Array.new
    @money_lent_stat = Statistics.new(t('stats.lent_money_title'), t('stats.lent_money_description'))
    @money_lent_stat.calculate_money_outside
    @money_for_next_loan_wave = Statistics.new(t('stats.next_wave_title'), t('stats.next_wave_description'))
    @money_for_next_loan_wave.calculate_money_on_next_wave
    @rate_of_medium_loans = Statistics.new(t('stats.rate_medium_loans_title'), t('stats.rate_medium_loans_description'))
    @rate_of_medium_loans.calculate_rate_medium_loans
    @rate_of_very_big_loans = Statistics.new(t('stats.rate_very_big_loans_title'), t('stats.rate_very_big_loans_description'))
    @rate_of_very_big_loans.calculate_rate_very_big_loans
    @cumulative_interests_on_loans = Statistics.new(t('stats.cumulative_interests_on_loans_title'), t('stats.cumulative_interests_on_loans_description'))
    @cumulative_interests_on_loans.calculate_cumulative_interests

    @stats << @money_lent_stat << @money_for_next_loan_wave << @rate_of_medium_loans << @rate_of_very_big_loans << @cumulative_interests_on_loans
  end

end
