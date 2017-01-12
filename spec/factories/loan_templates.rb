FactoryGirl.define do
  factory :loan_template do
    amount 1.5
    rate 1.5
    duration 1
    name "MyString"
    template_completed_before_id 1
  end
end
