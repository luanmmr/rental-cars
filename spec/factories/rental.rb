FactoryBot.define do
  factory :rental do
    code { 'XFB0000' }
    start_date { Time.zone.today + 2.days }
    end_date { 7.days.from_now }
    client { create(:client) }
    car_category { create(:car_category) }
    user { create(:user) }
  end
end
