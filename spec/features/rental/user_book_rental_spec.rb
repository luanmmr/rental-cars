require 'rails_helper'

feature 'User book a rental' do
  scenario 'successfully' do
    rental = create(:rental)
    car_model = create(:car_model, car_category: rental.car_category)
    create(:car, car_model: car_model)
    user = create(:user, email: 'teste_effective@gmail.com', password: '123456')

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    click_on 'XFB0000'
    click_on 'Efetivar'
    select 'Fiat Uno - Preto - RBY1995', from: 'Carros disponíveis'
    click_on 'Concluir'

    expect(page).to have_content('RBY1995')
    expect(page).to have_content('Jose')
    expect(page).to have_content('25498763123')
    expect(page).to have_content('X')
    expect(page).to have_content('Uno')
    expect(page).to have_content(rental.daily_price_total)
    expect(page).to have_content(rental.start_date.strftime('%d/%m/%Y'))
    expect(page).to have_content(rental.end_date.strftime('%d/%m/%Y'))
  end

  scenario 'and there is no car' do
    rental = create(:rental)

    login_as rental.user, scope: :user
    visit root_path
    click_on 'Locações'
    click_on 'XFB0000'
    click_on 'Efetivar'

    expect(page).to have_content('Nenhum carro para essa categoria está '\
                                 'disponível')
    expect(page).to have_no_button('Concluir')
  end
end
