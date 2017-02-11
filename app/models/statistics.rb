#  figure            :float
#  display_figure    :text
#  name              :text
#  description       :text

class Statistics
  attr_accessor :figure
  attr_accessor :display_figure
  attr_accessor :name
  attr_accessor :description

  MEDIUM_LOAN_SIZE = 5000000

  def initialize(name, description)
    self.name = name
    self.description = description
  end

  # all the money currently being lent
  def calculate_money_outside
    # we take all the loans currently running
    total_money = 0
    Loan.active_loans.each do |active_loan|
      total_money += active_loan.amount
    end
    self.figure = (total_money/1000000)
    self.display_figure = ' Millions MGA'
  end

  # all the money that we need when the current wave is finished
  def calculate_money_on_next_wave
    # we take all the loans currently running
    total_money = 0
    active_loans = Loan.active_loans_with_templates
    active_loans.each do |active_loan|
      past_loans_of_borrower = active_loan.borrower.loans.order(start_date: :asc).to_a
      past_loans_number = past_loans_of_borrower.count
      if past_loans_number > 1 && (past_loans_of_borrower[past_loans_number-1].amount == past_loans_of_borrower[past_loans_number-2].amount)
        total_money += past_loans_of_borrower[past_loans_number-1].amount
      elsif active_loan.loan_template
        # if there is a template linked, we try to find the next one to be able to extract the amount
        followings = active_loan.loan_template.following_loan_templates
        if followings.first
          total_money += followings.first.amount
        else
          total_money += active_loan.loan_template.amount
        end
      end
    end
    self.figure = (total_money/1000000)
    self.display_figure = ' Millions MGA'
  end

  # finds the proportion of small loans (below 5M MGA) in the amount of loans we have
  def calculate_rate_medium_loans
    # we take all the loans currently running
    total_of_medium_loans = 0
    total_money = 0
    active_loans = Loan.active_loans
    active_loans.each do |active_loan|
      total_money += active_loan.amount
      if active_loan.amount < MEDIUM_LOAN_SIZE
        total_of_medium_loans += active_loan.amount
      end
    end
    self.figure = ((total_of_medium_loans.to_f/total_money.to_f).round(3))*100
    self.display_figure = ' %'
  end



end
