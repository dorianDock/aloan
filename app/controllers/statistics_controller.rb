class StatisticsController < ApplicationController

  def index
    @stats = Array.new
    @a_stat = Statistics.new(t('stats.lent_money_title'), t('stats.lent_money_description'))
    @a_stat.calculate_money_outside
    @stats << @a_stat
  end

end
