require 'rails_helper'

feature 'Admin register car model' do
  scenario 'successfully' do
    create(:manufacturer)
    create(:car_category)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Carros'
    click_on 'Modelos'
    click_on 'Registrar novo modelo'
    fill_in 'Nome', with: 'Cronos'
    fill_in 'Ano', with: '2020'
    fill_in 'Motor', with: '1.8'
    fill_in 'Combustível', with: 'Gasolina'
    select 'Fiat', from: 'Fabricante'
    select 'X', from: 'Categoria'
    click_on 'Criar Modelo'

    expect(page).to have_content('Modelo registrado com sucesso')
    expect(page).to have_content('Cronos')
    expect(page).to have_content('2020')
    expect(page).to have_content('1.8')
    expect(page).to have_content('Gasolina')
    expect(page).to have_content('Fiat')
    expect(page).to have_content(/X/)
  end

  scenario 'and must fill in all fields' do
    user = create(:user)

    login_as(user, scope: :user)
    visit new_car_model_path
    click_on 'Criar Modelo'

    expect(page).to have_content('Você deve corrigir os seguintes erros para '\
                                 'continuar')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Ano não pode ficar em branco')
    expect(page).to have_content('Motor não pode ficar em branco')
    expect(page).to have_content('Combustível não pode ficar em branco')
    expect(page).to_not have_content('Modelo registrado com sucesso')
  end

  scenario 'name must be unique' do
    user = create(:user)
    create(:car_model)

    login_as(user, scope: :user)
    visit new_car_model_path
    fill_in 'Nome', with: 'Uno'
    fill_in 'Ano', with: '2018'
    fill_in 'Motor', with: '1.8'
    fill_in 'Combustível', with: 'Flex'
    click_on 'Criar Modelo'

    expect(page).to have_content('Você deve corrigir os seguintes erros para '\
                                 'continuar')
    expect(page).to have_content('Nome já está em uso')
    expect(page).to_not have_content('Modelo registrado com sucesso')
  end
end
