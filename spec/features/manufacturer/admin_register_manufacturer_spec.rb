require 'rails_helper'

feature 'Admin register manufacturer' do
  scenario 'successfully' do
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Carros'
    click_on 'Fabricantes'
    click_on 'Registrar novo fabricante'
    fill_in 'Nome', with: 'Fiat'
    click_on 'Criar Fabricante'

    expect(page).to have_content('Fiat')
    expect(page).to have_content('Fabricante registrada com sucesso')
  end

  scenario 'and must fill in all fields' do
    user = create(:user)

    login_as(user, scope: :user)
    visit cars_path
    click_on 'Fabricantes'
    click_on 'Registrar novo fabricante'
    click_on 'Criar Fabricante'

    expect(page).to have_content('Você deve corrigir os seguintes erros '\
                                 'para continuar')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to_not have_content('Fabricante registrada com sucesso')
  end

  scenario 'name must be unique' do
    create(:manufacturer)
    user = create(:user)

    login_as(user, scope: :user)
    visit cars_path
    click_on 'Fabricantes'
    click_on 'Registrar novo fabricante'
    fill_in 'Nome', with: 'Fiat'
    click_on 'Criar Fabricante'

    expect(page).to have_content('Você deve corrigir os seguintes erros para '\
                                 'continuar')
    expect(page).to have_content('Nome já está em uso')
    expect(page).to_not have_content('Fabricante registrada com sucesso')
  end

  scenario 'with single name' do
    user = create(:user)

    login_as(user, scope: :user)
    visit cars_path
    click_on 'Fabricantes'
    click_on 'Registrar novo fabricante'
    fill_in 'Nome', with: 'General Motors'
    click_on 'Criar Fabricante'

    expect(page).to have_content('Você deve corrigir os seguintes erros para '\
                                 'continuar')
    expect(page).to have_content('Nome não é válido')
    expect(page).to_not have_content('Fabricante registrada com sucesso')
  end
end
