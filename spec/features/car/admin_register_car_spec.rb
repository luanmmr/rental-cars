require 'rails_helper'

feature 'Admin register car' do
  scenario 'successfully' do
    user = create(:user)
    create(:car_model)
    create(:subsidiary)

    login_as user, scope: :user
    visit root_path
    click_on 'Carros'
    click_on 'Registrar novo carro'
    fill_in 'Placa', with: 'EAE8164'
    fill_in 'Cor', with: 'Cinza'
    fill_in 'Quilometragem', with: 2.000
    select 'Carrefour Giovanni Gronchi', from: 'Filial'
    select 'Fiat Uno | 2018 | 1.8 | Flex', from: 'Modelo do Carro'
    click_on 'Criar Carro'

    expect(page).to have_content('Carro registrado com sucesso')
    expect(page).to have_content('EAE8164')
    expect(page).to have_content('Uno')
    expect(page).to have_content('2018')
    expect(page).to have_content('1.8')
    expect(page).to have_content('Flex')
    expect(page).to have_content('Carrefour Giovanni Gronchi')
  end

  scenario 'and must fill all the fields' do
    user = create(:user)

    login_as user, scope: :user
    visit new_car_path
    click_on 'Criar Carro'

    expect(page).to have_content('Você deve corrigir os seguintes erros '\
                                 'para continuar')
    expect(page).to have_content('Cor não pode ficar em branco')
    expect(page).to have_content('Placa não pode ficar em branco')
    expect(page).to have_content('Quilometragem não pode ficar em branco')
    expect(page).to_not have_content('Carro registrado com sucesso')
  end

  scenario 'and license plate must be unique' do
    create(:car)
    user = create(:user)

    login_as user, scope: :user
    visit root_path
    click_on 'Carros'
    click_on 'Registrar novo carro'
    fill_in 'Placa', with: 'RBY1995'
    click_on 'Criar Carro'

    expect(page).to have_content('Você deve corrigir os seguintes erros '\
                                  'para continuar')
    expect(page).to have_content('Placa já está em uso')
    expect(page).to_not have_content('Carro registrado com sucesso')
  end

  scenario 'and must be authenticated' do
    visit new_car_path

    expect(current_path).to eq(new_user_session_path)
  end
end
