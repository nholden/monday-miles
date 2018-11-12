# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    large_profile_image_url 'https://dgalywyr863hv.cloudfront.net/pictures/athletes/4197670/1346139/6/large.jpg'
    sequence(:slug) { |n| "john-smith-#{n}" }
    strava_access_token_expires_at { 2.hours.from_now }
  end
end
