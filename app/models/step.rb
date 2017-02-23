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

  validates :is_done, inclusion: { in: [ true, false ] }
  validates :days_after_previous_milestone, allow_nil: true, numericality: { message: I18n.t('error.should_be_number')}
  validates :months_after_previous_milestone, allow_nil: true, numericality: { message: I18n.t('error.should_be_number')}

  validate :duration_inferior_to_max
  validate :receipt_amount_inferior_to_max
  validate :release_amount_inferior_to_max

  validate :date_or_delay_value
  validate :not_date_and_delay_value
  validate :loan_or_loan_template
  validate :not_loan_and_loan_template
  # validate :days_or_months_after_previous
  validate :not_days_and_months_after_previous

  module StepTypeEnum
    RELEASE = 'Release of fund'
    RECEIPT = 'Receipt'
  end


  def type
    the_type= self.step_type
    name_to_return = ''
    if the_type.label == StepTypeEnum::RELEASE
      name_to_return = StepTypeEnum::RELEASE
    end
    if the_type.label == StepTypeEnum::RECEIPT
      name_to_return = StepTypeEnum::RECEIPT
    end
    name_to_return
  end


  private

  # the months duration should always be inferior to the max allowed
  def duration_inferior_to_max
    if (!months_after_previous_milestone.blank?) && !loan_template_id.blank?
      if loan_template.maximum_step_months_duration < months_after_previous_milestone
        errors.add(:months_after_previous_milestone, I18n.t('step.should_be_less_than_max_duration'))
      end
    end
  end


  # the receipt amount should always be inferior to the max allowed
  def receipt_amount_inferior_to_max
    if (!amount.blank?) && !loan_template_id.blank?
      if type == StepTypeEnum::RECEIPT
        max_amount = loan_template.maximum_receipt_amount
        unless id.blank?
          max_amount = max_amount + amount
        end
        if max_amount < amount
          errors.add(:amount, I18n.t('step.should_be_less_than_max_amount', :possible_amount => max_amount))
        end
      end
    end
  end

  # the receipt amount should always be inferior to the max allowed
  def release_amount_inferior_to_max
    if (!amount.blank?) && !loan_template_id.blank?
      if type == StepTypeEnum::RELEASE
        max_amount = loan_template.maximum_release_amount
        unless id.blank?
          max_amount = max_amount + amount
        end
        if max_amount < amount
          errors.add(:amount, I18n.t('step.should_be_less_than_max_amount', :possible_amount => max_amount))
        end
      end
    end
  end



  # we should always have either a date value or a delay value for a step
  def date_or_delay_value
    if (expected_date.blank?) && (days_after_previous_milestone.blank?) && (months_after_previous_milestone.blank?)
      errors.add(:expected_date, I18n.t('step.at_least_date_or_delay_value'))
    end
  end
  def not_date_and_delay_value
    if !expected_date.blank? && (!days_after_previous_milestone.blank? || !months_after_previous_milestone.blank?)
      errors.add(:expected_date, I18n.t('step.not_date_and_delay_value'))
    end
  end

  # def days_or_months_after_previous
  #   if (days_after_previous_milestone.blank?) && (months_after_previous_milestone.blank?)
  #     errors.add(:days_after_previous_milestone, I18n.t('step.at_least_days_or_months_after_prev'))
  #   end
  # end
  def not_days_and_months_after_previous
    if !days_after_previous_milestone.blank? && !months_after_previous_milestone.blank?
      errors.add(:days_after_previous_milestone, I18n.t('step.not_days_and_months_after_prev'))
    end
  end

  def loan_or_loan_template
    if (loan_id.blank?) && (loan_template_id.blank?)
      errors.add(:loan_id, I18n.t('step.at_least_loan_or_template'))
    end
  end
  def not_loan_and_loan_template
    if !loan_id.blank? && !loan_template_id.blank?
      errors.add(:loan_id, I18n.t('step.not_loan_and_loan_template'))
    end
  end

end
