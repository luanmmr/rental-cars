require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'validates#name' do
    it 'verify presence' do
      client = Client.new

      client.valid?

      expect(client.errors.full_messages).to include('Nome não pode '\
                                                     'ficar em branco')
    end

    it 'must fail name with numbers' do
      client = Client.new(name: '123')

      client.valid?

      expect(client.errors.full_messages).to include('Nome não é válido')
    end
  end

  describe 'validates#email' do
    it 'verify presence' do
      client = Client.new

      client.valid?

      expect(client.errors.full_messages).to include('Email não pode '\
                                                     'ficar em branco')
    end

    it 'verify uniqueness' do
      create(:client)
      client = Client.new(email: 'JOSE@HOTMAIL.COM')

      client.valid?

      expect(client.errors.full_messages).to include('Email já está em uso')
    end

    it 'verify format without @' do
      client = Client.new(email: 'josehotmail.com')

      client.valid?

      expect(client.errors.full_messages).to include('Email não é válido')
    end

    it 'verify format without .' do
      client = Client.new(email: 'jose@hotmailcom')

      client.valid?

      expect(client.errors.full_messages).to include('Email não é válido')
    end
  end

  describe 'validates#document' do
    it 'verify presence' do
      client = Client.new

      client.valid?

      expect(client.errors.full_messages).to include('CPF não pode '\
                                                     'ficar em branco')
    end

    it 'verify presence' do
      client = Client.new

      client.valid?

      expect(client.errors.full_messages).to include('CPF não pode '\
                                                     'ficar em branco')
    end

    it 'verify if document length is greater than 11' do
      client = Client.new(document: '123456789123')

      client.valid?

      expect(client.errors.full_messages).to include('CPF é muito longo '\
                                                     '(máximo: 11 caracteres)')
    end

    it 'verify if document is a number' do
      client = Client.new(document: 'A123456789')

      client.valid?

      expect(client.errors.full_messages).to include('CPF não é um número')
    end

    it 'verify if document is a integer' do
      client = Client.new(document: 1.50)

      client.valid?

      expect(client.errors.full_messages).to include('CPF não é um número '\
                                                     'inteiro')
    end
  end

  describe '#name_document' do
    it 'successfully' do
      client = Client.new(name: 'Pedro', document: '46413732059')

      expect(client.name_document).to include('Pedro - 46413732059')
    end

    it 'incomplete datas - name' do
      client = Client.new(document: '46413732059')

      expect(client.name_document).to include('Cliente com dados incompletos')
    end

    it 'incomplete datas - name and document' do
      client = Client.new

      expect(client.name_document).to include('Cliente com dados incompletos')
    end
  end
end
