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

  validates :amount, presence: { message: I18n.t('loan_template.not_blank')}
  validates :rate, presence: { message: I18n.t('loan_template.not_blank')}
  validates :duration, presence: { message: I18n.t('loan_template.not_blank')}
  validates :name, presence: { message: I18n.t('loan_template.not_blank')}


  def prerequisite_name
    unless self.prerequisite.nil?
      prerequisite.name
    end
  end

end
