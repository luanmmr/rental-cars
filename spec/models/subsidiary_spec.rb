require 'rails_helper'

RSpec.describe Subsidiary, type: :model do
  describe 'validates#name' do
    it 'verify presence' do
      subsidiary = Subsidiary.new

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('Nome não pode '\
                                                         'ficar em branco')
    end
  end

  describe 'validates#address' do
    it 'verify presence' do
      subsidiary = Subsidiary.new

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('Endereço não pode '\
                                                         'ficar em branco')
    end
  end

  describe 'validates#cnpj' do
    it 'verify presence' do
      subsidiary = Subsidiary.new

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('CNPJ não pode '\
                                                         'ficar em branco')
    end

    it 'verify if cnpj length is 14' do
      subsidiary = Subsidiary.new(cnpj: '789920110001927')

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('CNPJ não possui o '\
                                                         'tamanho esperado '\
                                                         '(14 caracteres)')
    end

    it 'verify if cnpj only have numbers' do
      subsidiary = Subsidiary.new(cnpj: '7899A011000192')

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('CNPJ não é um número')
    end

    it 'verify if cnpj only have integer' do
      subsidiary = Subsidiary.new(cnpj: '49.221359000188')

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('CNPJ não é um '\
                                                         'número inteiro')
    end
  end

  describe 'validates#zip_code' do
    it 'verify presence' do
      subsidiary = Subsidiary.new

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('CEP não pode '\
                                                         'ficar em branco')
    end

    it 'verify if cep length is 8' do
      subsidiary = Subsidiary.new(zip_code: '584625789')

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('CEP não possui o '\
                                                         'tamanho esperado '\
                                                         '(8 caracteres)')
    end

    it 'verify if cep only have numbers' do
      subsidiary = Subsidiary.new(zip_code: '5246A5789')

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('CEP não é um número')
    end

    it 'verify if cep only have integer' do
      subsidiary = Subsidiary.new(zip_code: '58.625789')

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('CEP não é um '\
                                                         'número inteiro')
    end
  end

  describe 'validates#number' do
    it 'verify presence' do
      subsidiary = Subsidiary.new

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('Número não pode '\
                                                         'ficar em branco')
    end

    it 'verify uniqueness' do
      create(:subsidiary)
      subsidiary = Subsidiary.new(zip_code: '05724030', number: 50)

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('Número já está em '\
                                                         'uso')
    end

    it 'verify uniqueness' do
      create(:subsidiary)
      subsidiary = Subsidiary.new(number: 50)

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to_not include('Número já está '\
                                                             'em uso')
    end

    it 'verify if number only have numbers' do
      subsidiary = Subsidiary.new(number: '16A')

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('Número não é um '\
                                                         'número')
    end

    it 'verify if cep only have integer' do
      subsidiary = Subsidiary.new(number: 12.9)

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('Número não é um '\
                                                         'número inteiro')
    end
  end

  describe 'validates#district' do
    it 'verify presence' do
      subsidiary = Subsidiary.new

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('Bairro não pode '\
                                                         'ficar em branco')
    end
  end

  describe 'validates#state' do
    it 'verify presence' do
      subsidiary = Subsidiary.new

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('Estado não pode '\
                                                         'ficar em branco')
    end

    it 'verify if state length is 2' do
      subsidiary = Subsidiary.new

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('Estado não possui o '\
                                                         'tamanho esperado '\
                                                         '(2 caracteres)')
    end
  end

  describe 'validates#city' do
    it 'verify presence' do
      subsidiary = Subsidiary.new

      subsidiary.valid?

      expect(subsidiary.errors.full_messages).to include('Cidade não pode '\
                                                         'ficar em branco')
    end
  end

  describe '#full_description' do
    it 'successfully' do
      subsidiary = Subsidiary.new(name: 'Carrefour Giovanni Gronchi',
                                  address: 'Rua Alberto Augusto Alves')

      expect(subsidiary.full_description).to eq(
        'Carrefour Giovanni Gronchi: Rua Alberto Augusto Alves'
      )
    end

    it 'must return error message if subsidiary is incomplete' do
      subsidiary = Subsidiary.new

      expect(subsidiary.full_description).to eq(
        'Filial cadastrada incorretamente'
      )
    end
  end
end
