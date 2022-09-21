require 'rails_helper'

feature 'User view buttons' do
  scenario 'authenticated' do
    visit root_path

    expect(page).to_not have_link('Home Page')
    expect(page).to_not have_link('Filiais')
    expect(page).to_not have_link('Carros')
    expect(page).to_not have_link('Clientes')
    expect(page).to_not have_link('Categorias')
    expect(page).to_not have_link('Locações')
  end
end
