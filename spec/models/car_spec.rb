require 'rails_helper'

describe Car do
  describe 'validates#color' do
    it 'verify presence' do
      car_model = Car.new

      car_model.valid?

      expect(car_model.errors.full_messages).to include('Cor não pode ficar '\
                                                        'em branco')
    end
  end

  describe 'validates#license_plate' do
    it 'verify presence' do
      car_model = Car.new

      car_model.valid?

      expect(car_model.errors.full_messages).to include('Placa não pode ficar '\
                                                        'em branco')
    end

    it 'verify uniqueness' do
      create(:car)
      car = Car.new(license_plate: 'RBY1995')

      car.valid?

      expect(car.errors.full_messages).to include('Placa já está em uso')
    end

    it 'verify if license plate with 3 letters and 4 numbers' do
      car = Car.new(license_plate: 'RBY1995')

      car.valid?

      expect(car.errors.full_messages).to_not include('Placa não é válida')
    end

    it 'verify if license plate with 4 letters and 3 numbers' do
      car = Car.new(license_plate: 'RBY1A95')

      car.valid?

      expect(car.errors.full_messages).to_not include('Placa não é válida')
    end

    it 'verify if license plate with 5 letters and 2 numbers' do
      car = Car.new(license_plate: 'RBY1A9Z')

      car.valid?

      expect(car.errors.full_messages).to include('Placa não é válida')
    end

    it 'verify if license plate with 6 letters and 1 numbers' do
      car = Car.new(license_plate: 'RBY1AYZ')

      car.valid?

      expect(car.errors.full_messages).to include('Placa não é válida')
    end

    it 'verify if license plate with 2 letters and 5 numbers' do
      car = Car.new(license_plate: 'RB11775')

      car.valid?

      expect(car.errors.full_messages).to include('Placa não é válida')
    end

    it 'verify if license plate with 1 letters and 6 numbers' do
      car = Car.new(license_plate: 'R711775')

      car.valid?

      expect(car.errors.full_messages).to include('Placa não é válida')
    end

    it 'verify if license plate with 0 letters and 7 numbers' do
      car = Car.new(license_plate: '2711775')

      car.valid?

      expect(car.errors.full_messages).to include('Placa não é válida')
    end
  end

  describe 'validates#mileage' do
    it 'verify presence' do
      car_model = Car.new

      car_model.valid?

      expect(car_model.errors.full_messages).to include('Quilometragem não '\
                                                        'pode ficar em branco')
    end

    it 'verify if mileage e is a number' do
      car = Car.new(mileage: 'Número')

      car.valid?

      expect(car.errors.full_messages).to include('Quilometragem não é um '\
                                                  'número')
    end
  end

  describe '#full_description' do
    it 'successfully' do
      car = create(:car)

      expect(car.full_description).to eq('Fiat Uno - Preto - RBY1995')
    end

    it 'incomplete datas - car model' do
      car = Car.new(color: 'Verde', license_plate: 'XML1245')

      expect(car.full_description).to eq('Carro não cadastro corretamente')
    end

    it 'incomplete datas - license plate' do
      car_model = create(:car_model)
      car = Car.new(color: 'Verde', car_model: car_model)

      expect(car.full_description).to eq('Carro não cadastro corretamente')
    end

    it 'incomplete datas - color' do
      car_model = create(:car_model)
      car = Car.new(license_plate: 'XML1245', car_model: car_model)

      expect(car.full_description).to eq('Carro não cadastro corretamente')
    end
  end

  describe '#car_category' do
    it 'successfully' do
      car = create(:car)

      expect(car.car_category).to eq(car.car_model.car_category)
    end
  end
end
