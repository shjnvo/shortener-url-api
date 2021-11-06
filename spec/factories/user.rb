FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Johnd #{n}" }
    sequence(:email) { |n| "person#{n}@example.com" }
    password { '12345678' }
  end
end