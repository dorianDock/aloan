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
#  order                :integer          default("1")
#  loan_template_id     :integer
#

class Loan < ApplicationRecord

  class << self
    def lambda_past
      lambda { |l| l.contractual_end_date < Date.today }
    end
    def lambda_current
      lambda { |l| l.contractual_end_date >= Date.today && l.start_date <= Date.today }
    end
    def lambda_future
      lambda { |l| l.start_date > Date.today }
    end

    def finished_loans
      today = Date.today
      Loan.where('end_date IS NOT NULL AND contractual_end_date <= ?', today).to_a
    end

    def finished_loans_in_the_year
      today = Date.today
      first_day_of_year = DateTime.new(today.year,1,1)
      Loan.where('end_date IS NOT NULL AND contractual_end_date <= ? AND contractual_end_date >= ?', today, first_day_of_year).to_a
    end

    def active_loans
      today = Date.today
      tomorrow = today+1.day
      a_month_ago = today-1.month
      Loan.where('(contractual_end_date >= ? AND start_date < ?)
      OR (contractual_end_date >= ? AND start_date < ? AND end_date IS NULL)', today, tomorrow, a_month_ago, tomorrow).to_a
    end

    def active_loans_with_templates
      today = Date.today
      tomorrow = today+1.day
      a_month_ago = today-1.month
      Loan.includes(loan_template: [:following_loan_templates], borrower: [:loans]).where('(contractual_end_date >= ? AND start_date < ?)
      OR (contractual_end_date >= ? AND start_date < ? AND end_date IS NULL)', today, tomorrow, a_month_ago, tomorrow).to_a
    end
  end

  DAYS_IN_A_MONTH = 30
  belongs_to :borrower
  belongs_to :loan_template, optional: true
  has_many :steps

  validates :start_date, presence: { message: I18n.t('loan.not_blank')}
  validates :contractual_end_date, presence: { message: I18n.t('loan.not_blank')}
  validates :rate, presence: { message: I18n.t('loan.not_blank')}
  validates :amount, presence: { message: I18n.t('loan.not_blank')}
  validates :borrower_id, presence: { message: I18n.t('loan.not_blank')}
  # validate :end_date_is_after_start_date

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
    (self.contractual_end_date.to_date-self.start_date.to_date).to_i
  end

  # takes a number of days into a number in months
  def loan_duration_in_months
    integer_part = self.loan_duration / DAYS_IN_A_MONTH
    rest = self.loan_duration % DAYS_IN_A_MONTH
    total = integer_part
    if rest > 20
      total += 1
    elsif rest > 10 && rest <=20
      total += 0.5
    end
    total
  end


  def loan_status
    #:active, :planned, :late, :finished
    today = Date.today
    tomorrow = today+1.day
    a_month_ago = today-1.month

    if self.start_date > today
      :planned
    elsif (self.contractual_end_date >= today && self.start_date < tomorrow) || (self.contractual_end_date >= a_month_ago && self.start_date < tomorrow && self.end_date.nil?)
      :active
    elsif self.contractual_end_date < a_month_ago && self.end_date.nil?
      :late
    else
      :finished
    end
  end

  private

  # def end_date_is_after_start_date
  #   return if self.end_date.blank? || self.start_date.blank?
  #
  #   if self.end_date < self.start_date
  #     errors.add(:end_date, "cannot be before the start time")
  #   end
  # end


end
