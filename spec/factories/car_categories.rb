FactoryBot.define do
  factory :car_category do
    name { 'X' }
    daily_rate { 89.99 }
    car_insurance { 25.00 }
    third_party_insurance { 10.00 }
  end
end
