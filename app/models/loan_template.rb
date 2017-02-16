# == Schema Information
#
# Table name: loan_templates
#
#  id                           :integer          not null, primary key
#  amount                       :float
#  rate                         :float
#  duration                     :integer
#  name                         :string
#  template_completed_before_id :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#

class LoanTemplate < ApplicationRecord
  has_many :loans
  belongs_to :prerequisite, foreign_key: 'template_completed_before_id', class_name: 'LoanTemplate', optional: true
  has_many :following_loan_templates, :foreign_key => 'template_completed_before_id', :class_name => 'LoanTemplate'
  has_many :steps


  validates :amount, presence: { message: I18n.t('loan_template.not_blank')}
  validates :rate, presence: { message: I18n.t('loan_template.not_blank')}
  validates :duration, presence: { message: I18n.t('loan_template.not_blank')}
  validates :name, presence: { message: I18n.t('loan_template.not_blank')}

  scope :amount_order, -> { order(amount: :asc) }


  # the maximum amount that we should put on a release step
  def maximum_release_amount
    amount_of_release_steps = 0
    current_steps = self.steps.to_a
    release_steps = current_steps.select{|y| y.type == Step::StepTypeEnum::RELEASE}
    if release_steps.any?
      amount_of_release_steps = release_steps.map{|x| x.amount}.reduce(0, :+)
    end
    self.amount - amount_of_release_steps
  end

  # the maximum amount that we should put on a receipt step
  def maximum_receipt_amount
    amount_of_receipt_steps = 0
    current_steps = self.steps.to_a
    release_steps = current_steps.select{|y| y.type == Step::StepTypeEnum::RECEIPT}
    if release_steps.any?
      amount_of_receipt_steps = release_steps.map{|x| x.amount}.reduce(0, :+)
    end
    maximum_release_amount - amount_of_receipt_steps
  end

  def prerequisite_name
    unless self.prerequisite.nil?
      prerequisite.name
    end
  end

end
