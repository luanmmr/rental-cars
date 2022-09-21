require 'rails_helper'

RSpec.describe CarModel, type: :model do
  describe 'validates#name' do
    it 'verify presence' do
      car_model = CarModel.new

      car_model.valid?

      expect(car_model.errors.full_messages).to include('Nome não pode ficar '\
                                                        'em branco')
    end

    it 'verify uniqueness' do
      create(:car_model)
      car_model = CarModel.new(name: 'uno', year: '2018', motorization: '1.8',
                               fuel_type: 'Flex')
      car_model.valid?

      expect(car_model.errors.full_messages).to include('Nome já está em uso')
    end

    it 'verify uniqueness without year' do
      create(:car_model)
      car_model = CarModel.new(name: 'uno', motorization: '1.8',
                               fuel_type: 'Flex')
      car_model.valid?

      expect(car_model.errors.full_messages).to_not include('Nome já está em '\
                                                            'uso')
    end

    it 'verify uniqueness without motorization' do
      create(:car_model)
      car_model = CarModel.new(name: 'uno', year: '2018', fuel_type: 'Flex')

      car_model.valid?

      expect(car_model.errors.full_messages).to_not include('Nome já está em '\
                                                            'uso')
    end

    it 'verify uniqueness without fuel type' do
      create(:car_model)
      car_model = CarModel.new(name: 'uno', year: '2018', motorization: '1.8')

      car_model.valid?

      expect(car_model.errors.full_messages).to_not include('Nome já está em '\
                                                            'uso')
    end
  end

  describe 'validates#year' do
    it 'verify presence' do
      car_model = CarModel.new

      car_model.valid?

      expect(car_model.errors.full_messages).to include('Ano não pode ficar '\
                                                        'em branco')
    end
  end

  describe 'validates#motorization' do
    it 'verify presence' do
      car_model = CarModel.new

      car_model.valid?

      expect(car_model.errors.full_messages).to include('Motor não pode ficar '\
                                                        'em branco')
    end
  end

  describe 'validates#fuel_type' do
    it 'verify presence' do
      car_model = CarModel.new

      car_model.valid?

      expect(car_model.errors.full_messages).to include('Combustível não pode'\
                                                        ' ficar em branco')
    end
  end

  describe '#full_description' do
    it 'successfully' do
      car_model = create(:car_model)

      expect(car_model.full_description).to eq('Fiat Uno | 2018 | 1.8 | Flex')
    end

    it 'incomplete datas - manufacturer' do
      car_model = CarModel.new(name: 'Punto', year: '2018', motorization: '2.0',
                               fuel_type: 'Flex')

      expect(car_model.full_description).to eq('Este modelo foi criado '\
                                               'incompleto')
    end

    it 'incomplete datas - motorization' do
      manufacturer = create(:manufacturer)
      car_model = CarModel.new(name: 'Punto', year: '2018', fuel_type: 'Flex',
                               manufacturer: manufacturer)

      expect(car_model.full_description).to eq('Este modelo foi criado '\
                                               'incompleto')
    end

    it 'incomplete datas - year' do
      manufacturer = create(:manufacturer)
      car_model = CarModel.new(name: 'Punto', fuel_type: 'Flex',
                               manufacturer: manufacturer, motorization: '2.0')

      expect(car_model.full_description).to eq('Este modelo foi criado '\
                                               'incompleto')
    end

    it 'incomplete datas - fuel type' do
      manufacturer = create(:manufacturer)
      car_model = CarModel.new(name: 'Punto', year: '2018',
                               manufacturer: manufacturer, motorization: '2.0')

      expect(car_model.full_description).to eq('Este modelo foi criado '\
                                               'incompleto')
    end

    it 'incomplete datas - name' do
      manufacturer = create(:manufacturer)
      car_model = CarModel.new(year: '2018', fuel_type: 'Flex',
                               manufacturer: manufacturer, motorization: '2.0')

      expect(car_model.full_description).to eq('Este modelo foi criado '\
                                               'incompleto')
    end
  end
end
