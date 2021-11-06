FactoryBot.define do
  factory :short_url do
    sequence(:url) { |n| "https://example#{n}.com" }
  end
end
