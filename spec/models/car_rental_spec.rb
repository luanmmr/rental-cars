require 'rails_helper'

RSpec.describe CarRental, type: :model do
  describe '#check_car_category' do
    it 'car category and rental category are inserted correctly' do
      car_category = CarCategory.new(name: 'A')
      car_model = CarModel.new(name: 'Uno', car_category: car_category)
      car = Car.new(car_model: car_model)
      rental = Rental.new(car_category: car_category)
      car_rental = CarRental.new(car: car, rental: rental)

      car_rental.valid?

      expect(car_rental.errors.full_messages).to_not include(
        'Categoria do carro e da locação não são a mesma.'
      )
    end

    it 'car category and rental category are not inserted correctly' do
      car_category = CarCategory.new(name: 'A')
      other_car_category = CarCategory.new(name: 'B')
      car_model = CarModel.new(name: 'Uno', car_category: car_category)
      car = Car.new(car_model: car_model)
      rental = Rental.new(car_category: other_car_category)
      car_rental = CarRental.new(car: car, rental: rental)

      car_rental.valid?

      expect(car_rental.errors[:base]).to include('Categoria do carro e da '\
                                                  'locação não são a mesma.')
    end
  end

  describe '#rental_status_change' do
    it 'should change the status of the rental' do
      client = Client.new
      user = User.new
      car_category = CarCategory.new(name: 'A')
      car_model = CarModel.new(name: 'Uno', car_category: car_category)
      car = Car.new(car_model: car_model)
      rental = Rental.create!(start_date: Time.zone.today,
                              end_date: 1.day.from_now, client: client,
                              user: user, car_category: car_category)
      car_rental = CarRental.create!(car: car, rental: rental, end_mileage: 0,
                                     daily_price: 80.40, car_insurance: 40.50,
                                     third_party_insurance: 10,
                                     start_mileage: 150.40)

      expect(car_rental.rental.status).to eq('in_progress')
    end
  end
end
