require 'rails_helper'

RSpec.describe Manufacturer, type: :model do
  describe 'validates#name' do
    it 'verify presence' do
      manufacturer = Manufacturer.new

      manufacturer.valid?

      expect(manufacturer.errors.full_messages).to include('Nome não pode '\
                                                           'ficar em branco')
    end

    it 'verify uniqueness' do
      create(:manufacturer)
      manufacturer = Manufacturer.new(name: 'Fiat')

      manufacturer.valid?

      expect(manufacturer.errors.full_messages).to include('Nome já está em'\
                                                           ' uso')
    end

    it 'must fail with numbers' do
      create(:manufacturer)
      manufacturer = Manufacturer.new(name: '12')

      manufacturer.valid?

      expect(manufacturer.errors.full_messages).to include('Nome não é válido')
    end

    it 'must fail with one letter' do
      create(:manufacturer)
      manufacturer = Manufacturer.new(name: 'A')

      manufacturer.valid?

      expect(manufacturer.errors.full_messages).to include('Nome não é válido')
    end

    it 'must fail with compound name' do
      create(:manufacturer)
      manufacturer = Manufacturer.new(name: 'General Motors')

      manufacturer.valid?

      expect(manufacturer.errors.full_messages).to include('Nome não é válido')
    end
  end
end
