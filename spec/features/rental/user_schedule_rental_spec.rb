require 'rails_helper'

feature 'User schedule rental' do
  scenario 'successfully' do
    create(:car_category)
    create(:client)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Locações'
    click_on 'Agendar locação'
    fill_in 'Data de início', with: Time.zone.today
    fill_in 'Data de fim', with: 3.days.from_now
    select 'Jose', from: 'Cliente'
    select 'X', from: 'Categoria do Carro'
    click_on 'Criar Locação'

    expect(page).to have_content('Locação agendada com sucesso')
    expect(page).to have_content(Time.zone.today.strftime('%d/%m/%Y'))
    expect(page).to have_content(3.days.from_now.strftime('%d/%m/%Y'))
    expect(page).to have_content('Jose')
    expect(page).to have_content(/X/)
    expect(page).to have_content('jose@hotmail.com')
  end

  scenario 'and must fill in all fields' do
    user = User.create!(email: 'teste@hotmail.com', password: '123456')

    login_as user, scope: :user
    visit new_rental_path
    fill_in 'Data de início', with: ''
    fill_in 'Data de fim', with: ''
    click_on 'Criar Locação'

    expect(page).to have_content('Você deve corrigir os seguintes erros para '\
                                 'continuar')
    expect(page).to have_content('Data de início não pode ficar em branco')
    expect(page).to have_content('Data de fim não pode ficar em branco')
  end

  scenario 'and dates must be valid' do
    user = User.create!(email: 'teste@hotmail.com', password: '123456')

    login_as user, scope: :user
    visit new_rental_path
    fill_in 'Data de início', with: 2.days.ago
    fill_in 'Data de fim', with: 3.days.ago
    click_on 'Criar Locação'

    expect(page).to have_content('Data de início deve ser a partir da data '\
                                 'atual')
    expect(page).to have_content('Data de fim deve ser após data de início')
  end

  scenario 'with available car' do
    user = User.create!(email: 'teste@hotmail.com', password: '123456')
    client = Client.create!(name: 'Fulano', document: '2938248684',
                            email: 'fulano@test.com')
    car_category = CarCategory.create!(name: 'A', daily_rate: 72.20,
                                       car_insurance: 28.00,
                                       third_party_insurance: 10.00)
    Rental.create!(code: SecureRandom.hex(5), start_date: Time.zone.today,
                   end_date: 4.days.from_now, client: client,
                   car_category: car_category, user: user)
    subsidiary = Subsidiary.create(name: 'Aeroporto Congonhas',
                                   address: 'Rua Otávio Tarquínio De Souza, '\
                                   '379, Campo Belo, SP',
                                   cnpj: '28179836000114')
    manufacturer = Manufacturer.create!(name: 'Fiat')
    car_model = CarModel.create!(name: 'Uno', year: '2015', motorization: '1.5',
                                 fuel_type: 'flex', car_category: car_category,
                                 manufacturer: manufacturer)
    Car.create!(license_plate: 'EAE8171', color: 'Cinza', mileage: 158.40,
                subsidiary: subsidiary, car_model: car_model)

    login_as user, scope: :user
    visit new_rental_path
    fill_in 'Data de início', with: 1.day.from_now
    click_on 'Criar Locação'

    expect(page).to have_content('Não há carros dessa categoria disponível '\
                                 'para o período')
  end
end
