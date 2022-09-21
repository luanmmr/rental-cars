require 'rails_helper'

feature 'Admin destroys rental' do
  scenario 'successfully' do
    user = create(:user, email: 'pedro@gmail.com', password: '123456')
    create(:rental)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Locações'
    click_on 'XFB0000'
    click_on 'Cancelar'
    fill_in 'Motivo', with: 'Não tenho mais interação na locação'
    click_on 'Cancelar locação'

    expect(page).to have_content('Locação cancelada com sucesso')
  end

  scenario 'must be only possible to cancel 24h before ' do
    user = create(:user, email: 'pedro@gmail.com', password: '123456')
    create(:rental, start_date: Time.zone.tomorrow)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    click_on 'XFB0000'
    click_on 'Cancelar'

    expect(page).to have_content('Locação com menos de 24hrs para o início')
  end

  scenario 'must type reason for cancellation' do
    user = create(:user, email: 'pedro@gmail.com', password: '123456')
    create(:rental)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Locações'
    click_on 'XFB0000'
    click_on 'Cancelar'
    fill_in 'Motivo', with: ''
    click_on 'Cancelar locação'

    expect(page).to have_content('Motivo não pode ficar em branco')
  end
end
