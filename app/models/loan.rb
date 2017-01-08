# == Schema Information
#
# Table name: loans
#
#  id                   :integer          not null, primary key
#  start_date           :datetime
#  contractual_end_date :datetime
#  end_date             :datetime
#  is_late              :boolean
#  is_in_default        :boolean
#  amount               :float
#  rate                 :float
#  borrower_id          :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  loan_goal            :text
#

class Loan < ApplicationRecord

  DAYS_IN_A_MONTH = 30
  belongs_to :borrower

  validates :start_date, presence: { message: I18n.t('loan.not_blank')}
  validates :contractual_end_date, presence: { message: I18n.t('loan.not_blank')}
  validates :rate, presence: { message: I18n.t('loan.not_blank')}
  validates :amount, presence: { message: I18n.t('loan.not_blank')}
  validates :borrower_id, presence: { message: I18n.t('loan.not_blank')}


  scope :natural_order, -> { order(start_date: :asc) }
  scope :reverse_order, -> { order(start_date: :desc) }


  def beginning_difference_days
    # we want days
    (self.start_date.to_i-Time.now.to_i)/(3600*24)+1
  end

  def end_difference_days
    # we want days
    (self.contractual_end_date.to_i-Time.now.to_i)/(3600*24)+1
  end

  def interest
    self.amount*(self.rate/100)
  end

  def loan_duration
    (self.contractual_end_date.to_i-self.start_date.to_i)/(3600*24)+1
  end

  # takes a number of days into a number in months
  def loan_duration_in_months
    integer_part = self.loan_duration/DAYS_IN_A_MONTH
    rest = self.loan_duration%DAYS_IN_A_MONTH
    total = integer_part
    if rest > 20
      total += 1
    elsif rest > 10 && rest <=20
      total += 0.5
    end
    total
  end

end
