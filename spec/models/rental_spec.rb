require 'rails_helper'

describe Rental do
  describe 'validates#start_date' do
    it 'verify presence' do
      rental = Rental.new

      rental.valid?

      expect(rental.errors.full_messages).to include('Data de início não pode '\
                                                     'ficar em branco')
    end
  end

  describe 'validates#end_date' do
    it 'verify presence' do
      rental = Rental.new

      rental.valid?

      expect(rental.errors.full_messages).to include('Data de fim não pode '\
                                                     'ficar em branco')
    end
  end

  describe '#valid_start_date' do
    it 'should not validate the start date in the past' do
      rental = Rental.new(start_date: 1.day.ago)

      rental.valid?

      expect(rental.errors.full_messages).to include('Data de início deve ser '\
                                                    'a partir da data atual')
    end

    it 'start date is inserted correctly' do
      rental = Rental.new(start_date: Time.zone.today)

      rental.valid?

      expect(rental.errors.full_messages).to_not include('Data de início deve '\
                                                         'ser a partir da '\
                                                         'data atual')
    end
  end

  describe '#valid_end_date' do
    it 'should not let end date before the start date' do
      rental = Rental.new(start_date: Time.zone.today, end_date: 1.day.ago)

      rental.valid?

      expect(rental.errors.full_messages).to include('Data de fim deve ser '\
                                                  'após data de início')
    end

    it 'end date is inserted correctly' do
      rental = Rental.new(start_date: Time.zone.today, end_date: 1.day.from_now)

      rental.valid?

      expect(rental.errors.full_messages).to_not include('Data de fim deve ser'\
                                                         ' após data de início')
    end
  end

  describe '#availables_cars' do
    it 'inserted datas correctly' do
      car_category = create(:car_category)
      manufacturer = create(:manufacturer)
      car_model = create(:car_model, name: 'Uno', car_category: car_category,
                                     manufacturer: manufacturer)
      other_car_model = create(:car_model, name: 'Punto',
                                           car_category: car_category,
                                           manufacturer: manufacturer)
      create(:car, license_plate: 'JVA1996', car_model: car_model,
                   color: 'Vermelho', subsidiary: Subsidiary.new,
                   mileage: 100)
      create(:car, license_plate: 'CCC1972', color: 'Vermelho',
                   car_model: other_car_model, mileage: 100,
                   subsidiary: Subsidiary.new)
      create(:rental, code: 'RENTAL01', car_category: car_category,
                      client: Client.new, user: User.new,
                      start_date: 10.days.from_now, end_date: 17.days.from_now)
      create(:rental, code: 'RENTAL02', client: Client.new,
                      car_category: car_category, user: User.new,
                      start_date: 12.days.from_now, end_date: 19.days.from_now)
      another_rental = Rental.new(code: 'RENTAL03', client: Client.new,
                                  car_category: car_category, user: User.new,
                                  start_date: 20.days.from_now,
                                  end_date: 21.days.from_now)

      another_rental.valid?

      expect(another_rental.errors[:base]).to_not include('Não há carros '\
                                                          'dessa categoria '\
                                                          'disponível para o '\
                                                          'período')
    end

    it 'should not to allow more rentals than cars of the chosen category - '\
       'start date within chosen period' do
      car_category = create(:car_category)
      manufacturer = create(:manufacturer)
      car_model = create(:car_model, name: 'Uno', car_category: car_category,
                                     manufacturer: manufacturer)
      other_car_model = create(:car_model, name: 'Punto',
                                           car_category: car_category,
                                           manufacturer: manufacturer)
      create(:car, license_plate: 'JVA1996', car_model: car_model,
                   color: 'Vermelho', subsidiary: Subsidiary.new,
                   mileage: 100)
      create(:car, license_plate: 'CCC1972', color: 'Vermelho',
                   car_model: other_car_model, mileage: 100,
                   subsidiary: Subsidiary.new)
      create(:rental, code: 'RENTAL01', car_category: car_category,
                      client: Client.new, user: User.new,
                      start_date: 10.days.from_now, end_date: 17.days.from_now)
      create(:rental, code: 'RENTAL02', client: Client.new,
                      car_category: car_category, user: User.new,
                      start_date: 12.days.from_now, end_date: 19.days.from_now)
      another_rental = Rental.new(code: 'RENTAL03', client: Client.new,
                                  car_category: car_category, user: User.new,
                                  start_date: 13.days.from_now,
                                  end_date: 21.days.from_now)
      another_rental.valid?

      expect(another_rental.errors[:base]).to include('Não há carros dessa '\
                                                      'categoria disponível '\
                                                      'para o período')
    end

    it 'should not to allow more rentals than cars of the chosen category - '\
       'end date within chosen period' do
      car_category = create(:car_category)
      manufacturer = create(:manufacturer)
      car_model = create(:car_model, name: 'Uno', car_category: car_category,
                                     manufacturer: manufacturer)
      other_car_model = create(:car_model, name: 'Punto',
                                           car_category: car_category,
                                           manufacturer: manufacturer)
      create(:car, license_plate: 'JVA1996', car_model: car_model,
                   color: 'Vermelho', subsidiary: Subsidiary.new,
                   mileage: 100)
      create(:car, license_plate: 'CCC1972', color: 'Vermelho',
                   car_model: other_car_model, mileage: 100,
                   subsidiary: Subsidiary.new)
      create(:rental, code: 'RENTAL01', car_category: car_category,
                      client: Client.new, user: User.new,
                      start_date: 10.days.from_now, end_date: 17.days.from_now)
      create(:rental, code: 'RENTAL02', client: Client.new,
                      car_category: car_category, user: User.new,
                      start_date: 12.days.from_now, end_date: 19.days.from_now)
      another_rental = Rental.new(code: 'RENTAL03', client: Client.new,
                                  car_category: car_category, user: User.new,
                                  start_date: 8.days.from_now,
                                  end_date: 15.days.from_now)
      another_rental.valid?

      expect(another_rental.errors[:base]).to include('Não há carros dessa '\
                                                     'categoria disponível '\
                                                     'para o período')
    end

    it 'should not to allow more rentals than cars of the chosen category - '\
       'chosen period within start date and end date' do
      car_category = create(:car_category)
      manufacturer = create(:manufacturer)
      car_model = create(:car_model, name: 'Uno', car_category: car_category,
                                     manufacturer: manufacturer)
      other_car_model = create(:car_model, name: 'Punto',
                                           car_category: car_category,
                                           manufacturer: manufacturer)
      create(:car, license_plate: 'JVA1996', car_model: car_model,
                   color: 'Vermelho', subsidiary: Subsidiary.new,
                   mileage: 100)
      create(:car, license_plate: 'CCC1972', color: 'Vermelho',
                   car_model: other_car_model, mileage: 100,
                   subsidiary: Subsidiary.new)
      create(:rental, code: 'RENTAL01', car_category: car_category,
                      client: Client.new, user: User.new,
                      start_date: 10.days.from_now, end_date: 17.days.from_now)
      create(:rental, code: 'RENTAL02', client: Client.new,
                      car_category: car_category, user: User.new,
                      start_date: 12.days.from_now, end_date: 19.days.from_now)
      another_rental = Rental.new(code: 'RENTAL03', client: Client.new,
                                  car_category: car_category, user: User.new,
                                  start_date: 9.days.from_now,
                                  end_date: 20.days.from_now)
      another_rental.valid?

      expect(another_rental.errors[:base]).to include('Não há carros dessa '\
                                                    'categoria disponível '\
                                                    'para o período')
    end
  end

  describe '#daily_price_total' do
    it 'return sum of daily rate, car insurance and third party insurance' do
      rental = create(:rental)

      expect(rental.daily_price_total).to eq(rental.car_category.daily_rate +
                                            rental.car_category.car_insurance +
                                      rental.car_category.third_party_insurance)
    end

    it 'must be fail if rental was registred incomplete - car category' do
      rental = Rental.new

      expect(rental.daily_price_total).to eq('Locação cadastrada '\
                                             'incorretamente')
    end
  end

  describe '#car_insurance' do
    it 'return value of car insurance' do
      rental = create(:rental)

      expect(rental.car_insurance).to eq(rental.car_category.car_insurance)
    end

    it 'must be fail if rental was registred incomplete - car category' do
      rental = Rental.new

      expect(rental.car_insurance).to eq('Locação cadastrada incorretamente')
    end
  end

  describe '#third_party_insurance' do
    it 'return value of third party insurance' do
      rental = create(:rental)

      expect(rental.car_insurance).to eq(rental.car_category.car_insurance)
    end

    it 'must be fail if rental was registred incomplete - car category' do
      rental = Rental.new

      expect(rental.third_party_insurance).to eq('Locação cadastrada '\
                                                 'incorretamente')
    end
  end

  describe '#expired?' do
    it 'verify if start date has expired' do
      rental = Rental.new(start_date: Time.zone.yesterday)

      rental.rental_expired?

      expect(rental.errors.full_messages).to include('A locação expirou')
    end
  end
end
