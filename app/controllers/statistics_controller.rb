class StatisticsController < ApplicationController

  def index
    @stats = Array.new
    @a_stat = Statistics.new('Argent prêté', 'Argent actuellement prêté durant cette vague de prêts')
    @a_stat.calculate_money_outside
    @stats << @a_stat
  end

end
