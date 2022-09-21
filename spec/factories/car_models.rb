FactoryBot.define do
  factory :car_model do
    name { 'Uno' }
    year { '2018' }
    motorization { '1.8' }
    fuel_type { 'Flex' }
    car_category { create(:car_category) }
    manufacturer { create(:manufacturer) }
  end
end
