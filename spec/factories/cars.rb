FactoryBot.define do
  factory :car do
    license_plate { 'RBY1995' }
    color { 'Preto' }
    car_model { create(:car_model) }
    mileage { 1500 }
    subsidiary { create(:subsidiary) }
  end
end
