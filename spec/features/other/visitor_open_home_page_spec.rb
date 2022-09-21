require 'rails_helper'

feature 'Visitor open home page' do
  scenario 'successfully' do
    User.create!(email: 'testelogin@teste.com.br', password: '123456')

    visit root_path
    fill_in 'Email', with: 'testelogin@teste.com.br'
    fill_in 'Senha', with: '123456'
    click_on 'Entrar'

    expect(current_path).to eq(root_path)
    expect(page).to have_link('Home Page')
    expect(page).to have_link('Filiais')
    expect(page).to have_link('Carros')
    expect(page).to have_link('Clientes')
    expect(page).to have_link('Categorias')
    expect(page).to have_link('Locações')
  end
end
