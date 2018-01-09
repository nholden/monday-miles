FactoryGirl.define do
  factory :activity do

    polyline 'abc123'
    start_time { Time.current }
    utc_offset -480

    trait :last_monday do
      start_time { Time.current.monday + 12.hours }
      monday true
    end

    trait :two_mondays_ago do
      start_time { Time.current.monday + 12.hours - 1.week }
      monday true
    end

    trait :four_mondays_ago do
      start_time { Time.current.monday + 12.hours - 3.weeks }
      monday true
    end

    trait :wednesday do
      start_time { Time.current.monday + 12.hours + 2.days }
      monday false
    end

  end
end
