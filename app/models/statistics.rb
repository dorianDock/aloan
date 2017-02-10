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
    total_money = 0
    Loan.active_loans.each do |active_loan|
      total_money += active_loan.amount
    end
    self.figure = (total_money/1000000).to_i
  end

  # all the money that we need when the current wave is finished
  def calculate_money_on_next_wave
    # we take all the loans currently running
    total_money = 0
    active_loans = Loan.active_loans_with_templates
    active_loans.each do |active_loan|
      if active_loan.loan_template
        # if there is a template linked, we try to find the next one to be able to extract the amount
        followings = active_loan.loan_template.following_loan_templates
        if followings.first
          total_money += followings.first.amount
        end
      end
    end
    self.figure = (total_money/1000000).to_i
  end
end
