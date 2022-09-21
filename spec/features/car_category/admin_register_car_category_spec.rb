require 'rails_helper'

feature 'Admin register car category' do
  scenario 'successfully' do
    user = User.create!(email: 'test#@test.com', password: '123456')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Categorias'
    click_on 'Registrar nova categoria'
    fill_in 'Nome', with: 'A'
    fill_in 'Diária', with: 71.73
    fill_in 'Seguro do Carro', with: 28.00
    fill_in 'Seguro para Terceiros', with: 10.00
    click_on 'Criar Categoria'

    expect(page).to have_content('Categoria: A')
    expect(page).to have_content(71.73)
    expect(page).to have_content(28.00)
    expect(page).to have_content(10.00)
    expect(page).to have_content('Categoria registrada com sucesso')
  end

  scenario 'and must fill in all fields' do
    user = User.create!(email: 'test#@test.com', password: '123456')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Categorias'
    click_on 'Registrar nova categoria'
    click_on 'Criar Categoria'

    expect(page).to have_content('Você deve corrigir os seguintes erros para '\
                                 'continuar')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Diária não pode ficar em branco')
    expect(page).to have_content('Seguro do Carro não pode ficar em branco')
    expect(page).to have_content('Seguro para Terceiros não pode ficar em '\
                                 'branco')
    expect(page).to_not have_content('Categoria registrada com sucesso')
  end

  scenario 'name must be unique' do
    CarCategory.create(name: 'A', daily_rate: 72.20, car_insurance: 28.00,
                       third_party_insurance: 10)
    user = User.create!(email: 'test#@test.com', password: '123456')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Categorias'
    click_on 'Registrar nova categoria'
    fill_in 'Nome', with: 'A'
    click_on 'Criar Categoria'

    expect(page).to have_content('Nome já está em uso')
    expect(page).to_not have_content('Categoria registrada com sucesso')
  end

  scenario 'and must be authenticated' do
    visit new_car_category_path

    expect(current_path).to eq(new_user_session_path)
  end
end
