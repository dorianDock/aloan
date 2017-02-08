class StatisticsController < ApplicationController

  def index
    @stats = Array.new
    @stats << '1' << '2' << '3'
  end

end
