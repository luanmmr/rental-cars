require 'rails_helper'

feature 'Admin edit car' do
  scenario 'successfully' do
    user = create(:user)
    create(:subsidiary, name: 'Interlagos', cnpj: '92143681000611',
                        address: 'Av Interlagos', number: 70,
                        district: 'Jd Marajoara', zip_code: '75004203')
    car_category = create(:car_category, name: 'W', daily_rate: 109.99,
                                         car_insurance: 30.00,
                                         third_party_insurance: 15.00)
    manufacturer = create(:manufacturer, name: 'Honda')
    create(:car_model, name: 'Fit', motorization: '1.4', year: '2012',
                       car_category: car_category, manufacturer: manufacturer)
    car = create(:car)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Carros'
    within "td#car-#{car.id}" do
      click_on 'Editar'
    end
    fill_in 'Placa', with: 'MVU1245'
    select 'Honda Fit | 2012 | 1.4 | Flex', from: 'Modelo do Carro'
    select 'Interlagos', from: 'Filial'
    click_on 'Atualizar Carro'

    expect(page).to have_content('Carro atualizado com sucesso')
    expect(page).to have_content('MVU1245')
    expect(page).to have_content('Honda')
    expect(page).to have_content('Fit')
    expect(page).to have_content('Interlagos')
  end

  scenario 'and must fill in all fields' do
    user = User.create!(email: 'test#@test.com', password: '123456')
    car = Car.create!(license_plate: 'JSO1245', color: 'Azul',
                      car_model: CarModel.new, mileage: 100,
                      subsidiary: Subsidiary.new)

    login_as(user, scope: :user)
    visit edit_car_path(car)
    fill_in 'Placa', with: ''
    fill_in 'Cor', with: ''
    fill_in 'Quilometragem', with: ''
    click_on 'Atualizar Carro'

    expect(page).to have_content('Você deve corrigir os seguintes erros '\
                                  'para continuar')
    expect(page).to have_content('Cor não pode ficar em branco')
    expect(page).to have_content('Placa não pode ficar em branco')
    expect(page).to have_content('Quilometragem não pode ficar em branco')
    expect(page).to_not have_content('Carro atualizado com sucesso')
  end

  scenario 'and license plate must be unique' do
    user = create(:user)
    subsidiary = create(:subsidiary, name: 'Interlagos', number: 70,
                                     address: 'Av Interlagos',
                                     cnpj: '92143681000611',
                                     district: 'Jd Marajoara',
                                     zip_code: '75004203')
    car_category = create(:car_category, name: 'W', daily_rate: 109.99,
                                         car_insurance: 30.00,
                                         third_party_insurance: 15.00)
    manufacturer = create(:manufacturer, name: 'Honda')
    car_model = create(:car_model, name: 'Fit', motorization: '1.4',
                                   year: '2012', car_category: car_category,
                                   manufacturer: manufacturer)
    car = create(:car, car_model: car_model, subsidiary: subsidiary,
                       license_plate: 'RLS2004')
    create(:car)

    login_as user, scope: :user
    visit root_path
    click_on 'Carros'
    within "td#car-#{car.id}" do
      click_on 'Editar'
    end
    fill_in 'Placa', with: 'RBY1995'
    click_on 'Atualizar Carro'

    expect(page).to have_content('Você deve corrigir os seguintes erros '\
                                 'para continuar')
    expect(page).to have_content('Placa já está em uso')
    expect(page).to_not have_content('Carro atualizado com sucesso')
  end

  scenario 'and must be authenticated to edit a car' do
    visit edit_car_path(7)

    expect(current_path).to eq(new_user_session_path)
  end
end
