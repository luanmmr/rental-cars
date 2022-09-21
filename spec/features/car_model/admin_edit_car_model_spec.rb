require 'rails_helper'

feature 'Admin edits car model' do
  scenario 'successfully' do
    create(:manufacturer, name: 'Honda')
    create(:car_category, name: 'B')
    car_model = create(:car_model)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Carros'
    click_on 'Modelos'
    within "td#car_model-#{car_model.id}" do
      click_on 'Editar'
    end
    fill_in 'Nome', with: 'Fit'
    fill_in 'Ano', with: '2020'
    fill_in 'Motor', with: '1.8'
    fill_in 'Combustível', with: 'Gasolina'
    select 'Honda', from: 'Fabricante'
    select 'B', from: 'Categoria'
    click_on 'Atualizar Modelo'

    expect(page).to have_content('Modelo atualizado com sucesso')
    expect(page).to have_content('Fit')
    expect(page).to have_content('2020')
    expect(page).to have_content('1.8')
    expect(page).to have_content('Gasolina')
    expect(page).to have_content('Honda')
    expect(page).to have_content(/B/)
  end

  scenario 'and must fill in all fields' do
    car_model = create(:car_model)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Carros'
    click_on 'Modelos'
    within "td#car_model-#{car_model.id}" do
      click_on 'Editar'
    end
    fill_in 'Nome', with: ''
    fill_in 'Ano', with: ''
    fill_in 'Motor', with: ''
    fill_in 'Combustível', with: ''
    click_on 'Atualizar Modelo'

    expect(page).to have_content('Você deve corrigir os seguintes erros para '\
                                 'continuar')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Ano não pode ficar em branco')
    expect(page).to have_content('Motor não pode ficar em branco')
    expect(page).to have_content('Combustível não pode ficar em branco')
    expect(page).to_not have_content('Modelo atualizado com sucesso')
  end

  scenario 'and name must be unique' do
    user = create(:user)
    car_model = create(:car_model)
    manufacturer = create(:manufacturer, name: 'Honda')
    car_category = create(:car_category, name: 'W', daily_rate: 129.00,
                                         car_insurance: 30.00,
                                         third_party_insurance: 30.00)
    create(:car_model, manufacturer: manufacturer,
                       car_category: car_category,
                       year: '2019', motorization: '1.8',
                       fuel_type: 'Flex', name: 'Fit')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Carros'
    click_on 'Modelos'
    within "td#car_model-#{car_model.id}" do
      click_on 'Editar'
    end
    fill_in 'Nome', with: 'Fit'
    fill_in 'Ano', with: '2019'
    fill_in 'Combustível', with: 'Flex'
    fill_in 'Motor', with: '1.8'
    click_on 'Atualizar Modelo'

    expect(page).to have_content('Você deve corrigir os seguintes erros para '\
                                 'continuar')
    expect(page).to have_content('Nome já está em uso')
    expect(page).to_not have_content('Modelo atualizado com sucesso')
  end

  scenario 'and must be authenticated' do
    visit edit_car_category_path(7)

    expect(current_path).to eq(new_user_session_path)
  end
end
