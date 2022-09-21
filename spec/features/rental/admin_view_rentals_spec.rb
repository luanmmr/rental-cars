require 'rails_helper'

feature 'Admin view rentals' do
  scenario 'successfully' do
    user = User.create!(email: 'teste@teste.com.br', password: '123456')
    client = Client.create!(name: 'Jose', document: '25498763123',
                            email: 'jose@jose.com.br')
    other_client = Client.create!(name: 'Pedro', document: '25498769452',
                                  email: 'pedro@jose.com.br')
    car_category = CarCategory.create(name: 'A', daily_rate: '72.20',
                                      car_insurance: '28.00',
                                      third_party_insurance: '10.00')
    other_car_category = CarCategory.create(name: 'B', daily_rate: '92.20',
                                            car_insurance: '35.20',
                                            third_party_insurance: '10.00')
    Rental.create!(code: '12a120c4c7', start_date: Time.zone.today,
                   end_date: 2.days.from_now, client: client, user: user,
                   car_category: car_category)
    Rental.create!(code: '45a157c4b8', start_date: Time.zone.today,
                   end_date: 2.days.from_now, client: other_client,
                   car_category: other_car_category, user: user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Locações'

    expect(page).to have_content('12a120c4c7')
    expect(page).to have_content('45a157c4b8')
    expect(page).to have_content('Jose')
    expect(page).to have_content('Pedro')
    expect(page).to have_content('jose@jose.com.br')
    expect(page).to have_content('pedro@jose.com.br')
    expect(page).to have_content('A')
    expect(page).to have_content('B')
    expect(page).to have_content('Agendada', count: 2)
  end

  scenario 'and also view more details of an rental' do
    user = User.create!(email: 'teste@teste.com.br', password: '123456')
    client = Client.create!(name: 'Jose', document: '25498763123',
                            email: 'jose@jose.com.br')
    car_category = CarCategory.create(name: 'A', daily_rate: '72.20',
                                      car_insurance: '28.00',
                                      third_party_insurance: '10.00')
    Rental.create!(code: '12a120c4c7', start_date: Time.zone.today,
                   end_date: 2.days.from_now, client: client,
                   car_category: car_category, user: user)

    login_as(user, scope: :user)
    visit rentals_path
    click_on '12a120c4c7'

    expect(page).to have_content('12a120c4c7')
    expect(page).to have_content('Jose')
    expect(page).to have_content('jose@jose.com.br')
    expect(page).to have_content('A')
    expect(page).to have_content(Time.zone.today.strftime('%d/%m/%Y'))
    expect(page).to have_content(2.days.from_now.strftime('%d/%m/%Y'))
    expect(page).to have_content('teste@teste.com.br')
  end

  scenario 'and must be authenticated' do
    visit rentals_path

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'and must be authenticated for more details' do
    visit rental_path(7)

    expect(current_path).to eq(new_user_session_path)
  end
end
