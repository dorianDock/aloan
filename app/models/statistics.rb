#  figure            :float
#  name              :text
#  description       :text

class Statistics
  attr_accessor :figure
  attr_accessor :name
  attr_accessor :description

  def initialize(name, description)
    self.name = name
    self.description = description
  end

  # all the money currently being lent
  def calculate_money_outside
    # we take all the loans currently running
    today = Date.today
    tomorrow = today+1.day
    a_month_ago = today-1.month
    active_loans = Loan.where('contractual_end_date >= ? AND start_date < ?', a_month_ago, tomorrow).to_a
    total_money = 0
    active_loans.each do |active_loan|
      total_money += active_loan.amount
    end
    self.figure = total_money.to_i
  end
end
