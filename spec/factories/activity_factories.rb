FactoryGirl.define do
  factory :activity do

    trait :last_monday do
      start_time Time.current.monday
      monday true
    end

    trait :two_mondays_ago do
      start_time Time.current.monday - 1.week
      monday true
    end

    trait :four_mondays_ago do
      start_time Time.current.monday - 3.weeks
      monday true
    end

    trait :wednesday do
      start_time Time.current.monday + 2.days
      monday false
    end

  end
end
