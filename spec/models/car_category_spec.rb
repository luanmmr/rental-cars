require 'rails_helper'

RSpec.describe CarCategory, type: :model do
  describe 'validates#name' do
    it 'verify presence' do
      car_category = CarCategory.new

      car_category.valid?

      expect(car_category.errors.full_messages).to include('Nome não pode '\
                                                           'ficar em branco')
    end

    it 'verify uniqueness' do
      create(:car_category)
      car_category = CarCategory.new(name: 'X')

      car_category.valid?

      expect(car_category.errors.full_messages).to include('Nome já está em '\
                                                           'uso')
    end

    it 'verify uniqueness case insensitive' do
      create(:car_category)
      car_category = CarCategory.new(name: 'x')

      car_category.valid?

      expect(car_category.errors.full_messages).to include('Nome já está em '\
                                                           'uso')
    end

    it 'verify format with small letters' do
      car_category = CarCategory.new(name: 'z')

      car_category.valid?

      expect(car_category.errors.full_messages).to include('Nome não é válido')
    end

    it 'verify format with two letters' do
      car_category = CarCategory.new(name: 'AB')

      car_category.valid?

      expect(car_category.errors.full_messages).to include('Nome não é válido')
    end

    it 'verify format with compound name' do
      car_category = CarCategory.new(name: 'A B')

      car_category.valid?

      expect(car_category.errors.full_messages).to include('Nome não é válido')
    end
  end

  describe 'validates#daily_rate' do
    it 'verify presence' do
      car_category = CarCategory.new

      car_category.valid?

      expect(car_category.errors.full_messages).to include('Diária não pode '\
                                                           'ficar em branco')
    end

    it 'verify if daily rate is a number' do
      car_category = CarCategory.new(daily_rate: 'Número')

      car_category.valid?

      expect(car_category.errors.full_messages).to include('Diária não é um '\
                                                           'número')
    end

    it 'verify if daily rate is greater than 1' do
      car_category = CarCategory.new(daily_rate: 1)

      car_category.valid?

      expect(car_category.errors.full_messages).to include('Diária deve ser '\
                                                           'maior que 1')
    end
  end

  describe 'validates#car_insurance' do
    it 'verify presence' do
      car_category = CarCategory.new

      car_category.valid?

      expect(car_category.errors.full_messages).to include('Seguro do Carro '\
                                                           'não pode ficar '\
                                                           'em branco')
    end

    it 'verify if car insurance is a number' do
      car_category = CarCategory.new(car_insurance: 'Número')

      car_category.valid?

      expect(car_category.errors.full_messages).to include('Seguro do Carro '\
                                                           'não é um número')
    end

    it 'verify if car insurance is greater than 1' do
      car_category = CarCategory.new(car_insurance: 1)

      car_category.valid?

      expect(car_category.errors.full_messages).to include('Seguro do Carro '\
                                                           'deve ser maior '\
                                                           'que 1')
    end
  end

  describe 'validates#third_party_insurance' do
    it 'verify presence' do
      car_category = CarCategory.new

      car_category.valid?

      expect(car_category.errors.full_messages).to include('Seguro para '\
                                                           'Terceiros não '\
                                                           'pode ficar em '\
                                                           'branco')
    end

    it 'verify if third party insurance is a number' do
      car_category = CarCategory.new(third_party_insurance: 'Número')

      car_category.valid?

      expect(car_category.errors.full_messages).to include('Seguro para '\
                                                           'Terceiros não '\
                                                           'é um número')
    end

    it 'verify if car insurance is greater than 1' do
      car_category = CarCategory.new(third_party_insurance: 1)

      car_category.valid?

      expect(car_category.errors.full_messages).to include('Seguro para '\
                                                           'Terceiros deve '\
                                                           'ser maior que 1')
    end
  end
end
