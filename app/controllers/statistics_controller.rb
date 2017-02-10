class StatisticsController < ApplicationController

  def index
    @stats = Array.new
    @a_stat = Statistics.new(t('stats.lent_money_title'), t('stats.lent_money_description'))
    @a_stat.calculate_money_on_next_wave
    @stats << @a_stat
  end

end
