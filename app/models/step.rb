# == Schema Information
#
# Table name: steps
#
#  id                              :integer          not null, primary key
#  loan_id                         :integer
#  step_type_id                    :integer
#  expected_date                   :datetime
#  date_done                       :datetime
#  is_done                         :boolean
#  amount                          :float
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  loan_template_id                :integer
#  days_after_previous_milestone   :integer
#  months_after_previous_milestone :integer
#

class Step < ApplicationRecord
  # a step either belongs to a loan, either to a loan template
  belongs_to :loan, optional: true
  belongs_to :loan_template, optional: true
  belongs_to :step_type, required: true

  validates :amount, presence: { message: I18n.t('step.not_blank')}
  validates :expected_date, presence: { message: I18n.t('step.not_blank')}
  validates :is_done, inclusion: { in: [ true, false ] }

  validate :loan_or_loan_template
  validate :not_loan_and_loan_template
  validate :days_or_months_after_previous
  validate :not_days_and_months_after_previous




  private

  def days_or_months_after_previous
    if (days_after_previous_milestone.nil? || days_after_previous_milestone == '') && (months_after_previous_milestone.nil? || months_after_previous_milestone == '')
      errors.add(:days_after_previous_milestone, I18n.t('step.at_least_days_or_months_after_prev'))
    end
  end

  def not_days_and_months_after_previous
    if !days_after_previous_milestone.nil? && days_after_previous_milestone != '' && !months_after_previous_milestone.nil? && months_after_previous_milestone != ''
      errors.add(:days_after_previous_milestone, I18n.t('step.not_days_and_months_after_prev'))
    end
  end


  def loan_or_loan_template
    if (loan_id.nil? || loan_id == '') && (loan_template_id.nil? || loan_template_id == '')
      errors.add(:loan_id, I18n.t('step.at_least_loan_or_template'))
    end
  end

  def not_loan_and_loan_template
    if !loan_id.nil? && loan_id != '' && !loan_template_id.nil? && loan_template_id != ''
      errors.add(:loan_id, I18n.t('step.not_loan_and_loan_template'))
    end
  end

end
