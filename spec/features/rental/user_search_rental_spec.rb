require 'rails_helper'

feature 'User search rental' do
  scenario 'by exact code' do
    car_category = CarCategory.create!(name: 'A', daily_rate: 72.20,
                                       car_insurance: 28.00,
                                       third_party_insurance: 10.00)
    client = Client.create!(name: 'Fulano', document: '2938248684',
                            email: 'fulano@test.com')
    user = User.create!(email: 'teste@hotmail.com', password: '123456')
    Rental.create!(code: 'XFB0000', start_date: Time.zone.today,
                   end_date: 1.day.from_now, client: client, user: user,
                   car_category: car_category)
    Rental.create!(code: 'XFB0001', start_date: Time.zone.today,
                   end_date: 1.day.from_now, client: client, user: user,
                   car_category: car_category)
    Rental.create!(code: 'XFB0000', start_date: Time.zone.today, user: user,
                   end_date: 1.day.from_now, client: client,
                   car_category: car_category)

    login_as(user, scopo: :user)
    visit root_path
    click_on 'Locações'
    within 'form' do
      fill_in 'Pesquisa', with: 'XFB0000'
      click_on 'Buscar'
    end

    expect(page).to have_content('XFB0000')
    expect(page).to have_content('Fulano')
    expect(page).to have_content('fulano@test.com')
    expect(page).to have_content('2 resultado(s) encontrado(s)')
    expect(page).to_not have_content('XFB0001')
  end

  scenario 'and not found' do
    car_category =  CarCategory.create!(name: 'A', daily_rate: 72.20,
                                        car_insurance: 28.00,
                                        third_party_insurance: 10.00)
    client = Client.create!(name: 'Fulano', document: '2938248684',
                            email: 'fulano@test.com')
    user = User.create!(email: 'teste@hotmail.com', password: '123456')
    Rental.create!(code: 'XFB0000', start_date: Time.zone.today,
                   end_date: 1.day.from_now, client: client, user: user,
                   car_category: car_category)

    login_as(user, scopo: :user)
    visit root_path
    click_on 'Locações'
    within 'form' do
      fill_in 'Pesquisa', with: 'XFB0001'
      click_on 'Buscar'
    end

    expect(page).to have_content('0 resultado(s) encontrado(s)')
    expect(page).to_not have_content('XFB0000')
  end

  scenario 'partially' do
    car_category = CarCategory.create!(name: 'A', daily_rate: 72.20,
                                       car_insurance: 28.00,
                                       third_party_insurance: 10.00)
    client = Client.create!(name: 'Fulano', document: '2938248684',
                            email: 'fulano@test.com')
    user = User.create!(email: 'teste@hotmail.com', password: '123456')
    Rental.create!(code: 'XFB0000', start_date: Time.zone.today,
                   end_date: 1.day.from_now, client: client, user: user,
                   car_category: car_category)
    Rental.create!(code: 'XFB0001', start_date: Time.zone.today,
                   end_date: 1.day.from_now, client: client, user: user,
                   car_category: car_category)
    Rental.create!(code: 'FXB0000', start_date: Time.zone.today,
                   end_date: 1.day.from_now, client: client, user: user,
                   car_category: car_category)

    login_as(user, scope: :user)
    visit rentals_path
    within 'form' do
      fill_in 'Pesquisa', with: 'xf'
      click_on 'Buscar'
    end

    expect(page).to have_content('XF', count: 2)
    expect(page).to_not have_content('FXB0000')
  end
end
