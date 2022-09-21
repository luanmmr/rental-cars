require 'rails_helper'

describe 'Car Management', type: :request do
  context '#show' do
    it 'render a json of a single car successfully' do
      car = create(:car)

      get api_v1_car_path(car)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(json[:license_plate]).to eq('RBY1995')
      expect(json[:color]).to eq('Preto')
      expect(json[:car_model_id]).to eq(car.car_model.id)
      expect(json[:subsidiary_id]).to eq(car.subsidiary.id)
    end

    it 'cannot find object car' do
      get api_v1_car_path(id: 777)

      expect(response).to have_http_status(:not_found)
    end
  end

  context '#index' do
    it 'render a json of all the cars successfully' do
      car = create(:car)
      car_category = create(:car_category, name: 'W')
      manufacturer = create(:manufacturer, name: 'Honda')
      car_model = create(:car_model, name: 'Fit', car_category: car_category,
                                     manufacturer: manufacturer)
      subsidiary = create(:subsidiary, name: 'Interlagos',
                                       address: 'Av Interlagos',
                                       district: 'Interlagos',
                                       zip_code: '07504203')
      other_car = create(:car, license_plate: 'RLS2004', subsidiary: subsidiary,
                               car_model: car_model)

      get api_v1_cars_path
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(json.length).to eq(2)
      expect(json[0][:license_plate]).to eq('RBY1995')
      expect(json[0][:color]).to eq('Preto')
      expect(json[0][:car_model_id]).to eq(car.car_model.id)
      expect(json[0][:subsidiary_id]).to eq(car.subsidiary.id)
      expect(json[1][:license_plate]).to eq('RLS2004')
      expect(json[1][:color]).to eq('Preto')
      expect(json[1][:car_model_id]).to eq(other_car.car_model.id)
      expect(json[1][:subsidiary_id]).to eq(other_car.subsidiary.id)
    end

    it 'there are no registered cars' do
      get api_v1_cars_path

      expect(response).to have_http_status(204)
      expect(response.body).to eq('')
    end
  end

  context '#create' do
    it 'should create a car' do
      subsidiary = create(:subsidiary)
      car_model = create(:car_model)

      post api_v1_cars_path, params: { license_plate: 'RLS4216', color: 'Preto',
                                       car_model_id: car_model.id, mileage: 100,
                                       subsidiary_id: subsidiary.id }
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(201)
      expect(json[:license_plate]).to eq('RLS4216')
      expect(json[:color]).to eq('Preto')
      expect(json[:car_model_id]).to eq(car_model.id)
      expect(json[:subsidiary_id]).to eq(subsidiary.id)
    end

    it 'should fail to create a car with invalid data' do
      post api_v1_cars_path, params: {}
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(412)
      expect(json).to include('Modelo do Carro é obrigatório(a)')
      expect(json).to include('Filial é obrigatório(a)')
      expect(json).to include('Placa não pode ficar em branco')
    end
  end

  context '#update' do
    it 'should update car' do
      car = create(:car)

      patch api_v1_car_path(car), params: { license_plate: 'JVA1995',
                                            color: 'Preto' }
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(json[:license_plate]).to eq('JVA1995')
      expect(json[:color]).to eq('Preto')
      expect(json[:mileage]).to eq(format('%.1f', car.mileage))
      expect(json[:car_model_id]).to eq(car.car_model.id)
      expect(json[:subsidiary_id]).to eq(car.subsidiary.id)
    end

    it 'cannot find object car' do
      patch api_v1_car_path(id: 777)

      expect(response).to have_http_status(404)
    end

    it 'should fail to update a car with empty datas' do
      car = create(:car)

      patch api_v1_car_path(car), params: {}

      expect(response).to have_http_status(412)
      expect(response.body).to eq('Não houve atualização')
    end
  end
end
