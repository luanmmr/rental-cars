require 'rails_helper'

feature 'Admin edits subsidiary' do
  scenario 'successfully' do
    subsidiary = create(:subsidiary)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Filiais'
    within "div#subsidiary-#{subsidiary.id}" do
      click_on 'Editar'
    end
    fill_in 'Nome', with: 'Interlagos'
    fill_in 'Endereço', with: 'Av Interlagos'
    fill_in 'CNPJ', with: '36232196000197'
    fill_in 'CEP', with: '04777000'
    fill_in 'Número', with: '5800'
    fill_in 'Bairro', with: 'Marajoara'
    fill_in 'Cidade', with: 'São Paulo'
    fill_in 'Estado', with: 'SP'
    click_on 'Atualizar Filial'

    expect(page).to have_content('Interlagos')
    expect(page).to have_content('Av Interlagos')
    expect(page).to have_content('36232196000197')
    expect(page).to have_content('04777000')
    expect(page).to have_content('5800')
    expect(page).to have_content('Marajoara')
  end

  scenario 'and must fill in all fields' do
    subsidiary = create(:subsidiary)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Filiais'
    within "div#subsidiary-#{subsidiary.id}" do
      click_on 'Editar'
    end
    fill_in 'Nome', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Endereço', with: ''
    fill_in 'Número', with: ''
    fill_in 'Bairro', with: ''
    fill_in 'CEP', with: ''
    fill_in 'Estado', with: ''
    fill_in 'Cidade', with: ''
    click_on 'Atualizar Filial'

    expect(page).to have_content('Você deve corrigir os seguintes erros para '\
                                 'continuar')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Endereço não pode ficar em branco')
    expect(page).to have_content('CNPJ não pode ficar em branco')
    expect(page).to have_content('CEP não pode ficar em branco')
    expect(page).to have_content('Número não pode ficar em branco')
    expect(page).to have_content('Bairro não pode ficar em branco')
    expect(page).to have_content('Estado não pode ficar em branco')
    expect(page).to have_content('Cidade não pode ficar em branco')
  end

  scenario 'and must be authenticated' do
    visit edit_car_category_path(7)

    expect(current_path).to eq(new_user_session_path)
  end
end
