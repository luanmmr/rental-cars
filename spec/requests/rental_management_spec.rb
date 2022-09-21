require 'rails_helper'

describe 'Rental Management', type: :request do
  context '#create' do
    it 'should create rental' do
      user = User.create!(email: 'teste@teste.com.br', password: '123456')
      client = Client.create!(name: 'Jose', document: '25498763123',
                              email: 'jose@jose.com.br')
      car_category = CarCategory.create!(name: 'A', daily_rate: '72.20',
                                         car_insurance: '28.00',
                                         third_party_insurance: '10.00')

      post api_v1_rentals_path, params: { code: '12a120c4c7',
                                          start_date: Time.zone.today,
                                          end_date: 2.days.from_now,
                                          client_id: client.id,
                                          user_id: user.id,
                                          car_category_id: car_category.id }
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(json[:code]).to eq('12a120c4c7')
      expect(json[:start_date]).to eq(Time.zone.today.strftime('%Y-%m-%d'))
      expect(json[:end_date]).to eq(2.days.from_now.strftime('%Y-%m-%d'))
      expect(json[:client_id]).to eq(client.id)
      expect(json[:user_id]).to eq(user.id)
      expect(json[:car_category_id]).to eq(car_category.id)
    end

    it 'should fail to create a rental with invalid datas' do
      post api_v1_rentals_path, params: {}
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(412)
      expect(json).to include('Cliente é obrigatório(a)')
      expect(json).to include('Categoria do Carro é obrigatório(a)')
      expect(json).to include('Usuário é obrigatório(a)')
      expect(json).to include('Data de início não pode ficar em branco')
      expect(json).to include('Data de fim não pode ficar em branco')
    end

    it 'and start date cannot be before today' do
      car_category = create(:car_category)
      post api_v1_rentals_path, params: { code: '12a120c4c7',
                                          start_date: 1.day.ago,
                                          end_date: 2.days.ago,
                                          client: create(:client),
                                          car_category_id: car_category.id,
                                          user: create(:user) }
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(412)
      expect(json).to include('Data de início deve ser a partir da data atual')
      expect(json).to include('Data de fim deve ser após data de início')
    end

    it 'no car for the chosen start date and end date' do
      car_category = create(:car_category)
      manufacturer = create(:manufacturer)
      car_model = create(:car_model, name: 'Uno', car_category: car_category,
                                     manufacturer: manufacturer)
      other_car_model = create(:car_model, name: 'Punto',
                                           car_category: car_category,
                                           manufacturer: manufacturer)
      create(:car, license_plate: 'JVA1996', car_model: car_model,
                   color: 'Vermelho', subsidiary: Subsidiary.new, mileage: 100)
      create(:car, license_plate: 'CCC1972', color: 'Vermelho', mileage: 100,
                   car_model: other_car_model, subsidiary: Subsidiary.new)
      create(:rental, code: 'RENTAL01', car_category: car_category,
                      client: Client.new, user: User.new,
                      start_date: 10.days.from_now, end_date: 17.days.from_now)
      create(:rental, code: 'RENTAL02', client: Client.new,
                      car_category: car_category, user: User.new,
                      start_date: 12.days.from_now, end_date: 19.days.from_now)

      post api_v1_rentals_path, params: { code: 'RENTAL03', user: User.new,
                                          client: Client.new,
                                          car_category_id: car_category.id,
                                          start_date: 9.days.from_now,
                                          end_date: 20.days.from_now }
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(412)
      expect(json).to include('Não há carros dessa categoria disponível '\
                              'para o período')
    end

    it 'no car for the chosen start date' do
      car_category = create(:car_category)
      manufacturer = create(:manufacturer)
      car_model = create(:car_model, name: 'Uno', car_category: car_category,
                                     manufacturer: manufacturer)
      other_car_model = create(:car_model, name: 'Punto',
                                           car_category: car_category,
                                           manufacturer: manufacturer)
      create(:car, license_plate: 'JVA1996', car_model: car_model,
                   color: 'Vermelho', subsidiary: Subsidiary.new, mileage: 100)
      create(:car, license_plate: 'CCC1972', color: 'Vermelho', mileage: 100,
                   car_model: other_car_model, subsidiary: Subsidiary.new)
      create(:rental, code: 'RENTAL01', car_category: car_category,
                      client: Client.new, user: User.new,
                      start_date: 10.days.from_now, end_date: 17.days.from_now)
      create(:rental, code: 'RENTAL02', client: Client.new,
                      car_category: car_category, user: User.new,
                      start_date: 12.days.from_now, end_date: 19.days.from_now)

      post api_v1_rentals_path, params: { code: 'RENTAL03', user: User.new,
                                          client: Client.new,
                                          car_category_id: car_category.id,
                                          start_date: 13.days.from_now,
                                          end_date: 21.days.from_now }
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(412)
      expect(json).to include('Não há carros dessa categoria disponível '\
                              'para o período')
    end

    it 'no car for the chosen end date' do
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
      create(:car, license_plate: 'CCC1972', color: 'Vermelho', mileage: 100,
                   car_model: other_car_model, subsidiary: Subsidiary.new)
      create(:rental, code: 'RENTAL01', car_category: car_category,
                      client: Client.new, user: User.new,
                      start_date: 10.days.from_now, end_date: 17.days.from_now)
      create(:rental, code: 'RENTAL02', client: Client.new,
                      car_category: car_category, user: User.new,
                      start_date: 12.days.from_now, end_date: 19.days.from_now)

      post api_v1_rentals_path, params: { code: 'RENTAL03', user: User.new,
                                          client: Client.new,
                                          car_category_id: car_category.id,
                                          start_date: 2.days.from_now,
                                          end_date: 14.days.from_now }
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(412)
      expect(json).to include('Não há carros dessa categoria disponível '\
                              'para o período')
    end
  end

  context '#client_rentals' do
    it 'must return all client rentals' do
      client = create(:client)
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
      create(:car, license_plate: 'CCC1972', color: 'Vermelho', mileage: 100,
                   car_model: other_car_model, subsidiary: Subsidiary.new)
      rental = create(:rental, code: 'RENTAL01', car_category: car_category,
                               client: client, user: User.new,
                               start_date: 10.days.from_now,
                               end_date: 17.days.from_now)
      other_rental = create(:rental, code: 'RENTAL02', client: client,
                                     car_category: car_category, user: User.new,
                                     start_date: 12.days.from_now,
                                     end_date: 19.days.from_now)

      get rentals_api_v1_client_path(id: client.document)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(json.length).to eq(2)
      expect(json[0][:code]).to eq('RENTAL01')
      expect(json[0][:start_date]).to eq(rental.start_date.strftime('%Y-%m-%d'))
      expect(json[0][:end_date]).to eq(rental.end_date.strftime('%Y-%m-%d'))
      expect(json[0][:status]).to eq('scheduled')
      expect(json[0][:client][:name]).to eq('Jose')
      expect(json[0][:client][:document]).to eq('25498763123')
      expect(json[0][:car_category][:name]).to eq('X')
      expect(json[1][:code]).to eq('RENTAL02')
      expect(json[1][:start_date]).to eq(
        other_rental.start_date.strftime('%Y-%m-%d')
      )
      expect(json[1][:end_date]).to eq(
        other_rental.end_date.strftime('%Y-%m-%d')
      )
      expect(json[1][:status]).to eq('scheduled')
      expect(json[1][:client][:name]).to eq('Jose')
      expect(json[1][:client][:document]).to eq('25498763123')
      expect(json[1][:car_category][:name]).to eq('X')
    end

    it 'cannot found client document' do
      get rentals_api_v1_client_path(id: '11111163123')

      expect(response).to have_http_status(404)
    end
  end

  describe '#show' do
    it 'must view rental details' do
      client = create(:client)
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
      create(:car, license_plate: 'CCC1972', color: 'Vermelho', mileage: 100,
                   car_model: other_car_model, subsidiary: Subsidiary.new)
      rental = create(:rental, code: 'RENTAL01', car_category: car_category,
                               client: client, user: User.new,
                               start_date: 10.days.from_now,
                               end_date: 17.days.from_now)
      create(:rental, code: 'RENTAL02', client: client,
                      car_category: car_category, user: User.new,
                      start_date: 12.days.from_now, end_date: 19.days.from_now)

      get api_v1_rental_path(rental)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(json[:code]).to eq('RENTAL01')
      expect(json[:start_date]).to eq(rental.start_date.strftime('%Y-%m-%d'))
      expect(json[:end_date]).to eq(rental.end_date.strftime('%Y-%m-%d'))
      expect(json[:status]).to eq('scheduled')
      expect(json[:client][:name]).to eq('Jose')
      expect(json[:client][:document]).to eq('25498763123')
      expect(json[:car_category][:name]).to eq('X')
    end

    it 'cannot found rental id' do
      get api_v1_rental_path(id: 7777)

      expect(response).to have_http_status(404)
    end
  end
end
