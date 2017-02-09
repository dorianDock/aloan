class StatisticsController < ApplicationController

  def index
    @stats = Array.new
    @a_stat = Statistics.new('Argent a debourser', 'argent à debourser lors de la prochaine vague de prêts')
    @a_stat.figure = 1000
    @stats << @a_stat
  end

end
