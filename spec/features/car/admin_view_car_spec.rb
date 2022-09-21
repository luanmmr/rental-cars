require 'rails_helper'

feature 'Admin view car' do
  scenario 'successfully' do
    user = create(:user)
    create(:car)
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
    create(:car, car_model: car_model, subsidiary: subsidiary,
                 license_plate: 'RLS2004')

    login_as user, scope: :user
    visit root_path
    click_on 'Carros'

    expect(page).to have_content('RBY1995')
    expect(page).to have_content('Fiat')
    expect(page).to have_content('Uno')
    expect(page).to have_content('Carrefour Giovanni Gronchi')
    expect(page).to have_content('RLS2004')
    expect(page).to have_content('Honda')
    expect(page).to have_content('Fit')
    expect(page).to have_content('Interlagos')
  end

  scenario 'and also details' do
    user = create(:user)
    create(:car)

    login_as user, scope: :user
    visit cars_path
    click_on 'RBY1995'

    expect(page).to have_content('RBY1995')
    expect(page).to have_content('Fiat')
    expect(page).to have_content('Uno')
    expect(page).to have_content('2018')
    expect(page).to have_content('1.8')
    expect(page).to have_content('Flex')
    expect(page).to have_content('Preto')
    expect(page).to have_content('Carrefour Giovanni Gronchi')
  end

  scenario 'and must be authenticated' do
    visit cars_path

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'and must be authenticated to access details' do
    visit car_path(7)

    expect(current_path).to eq(new_user_session_path)
  end
end
