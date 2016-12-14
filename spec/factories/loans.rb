FactoryGirl.define do
  factory :loan do
    start_date "2016-12-14 13:47:13"
    contractual_end_date "2016-12-14 13:47:13"
    end_date "2016-12-14 13:47:13"
    is_late false
    is_in_default false
    amount 1.5
    rate 1.5
    borrower_id 1
  end
end
