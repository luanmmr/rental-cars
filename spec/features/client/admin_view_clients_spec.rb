require 'rails_helper'

feature 'Admin view clients' do
  scenario 'successfully' do
    user = User.create!(email: 'teste@hotmail.com', password: '123456')
    Client.create!(name: 'Jose', document: '25498763123',
                   email: 'jose@jose.com.br')
    Client.create!(name: 'Pedro', document: '25498769452',
                   email: 'pedro@jose.com.br')

    login_as user, scope: :user
    visit root_path
    click_on 'Clientes'

    expect(page).to have_content('Jose')
    expect(page).to have_content('Pedro')
    expect(page).to have_content('jose@jose.com.br')
    expect(page).to have_content('pedro@jose.com.br')
    expect(page).to have_content('25498763123')
    expect(page).to have_content('25498769452')
  end
end
