FactoryBot.define do
  factory :cancel_rental do
    rental { nil }
    reason { 'MyText' }
  end
end
