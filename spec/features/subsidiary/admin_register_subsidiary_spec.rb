require 'rails_helper'

feature 'Admin register subsidiary' do
  scenario 'successfully' do
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Filiais'
    click_on 'Registrar nova filial'
    fill_in 'Nome', with: 'Interlagos'
    fill_in 'CNPJ', with: '28179836000114'
    fill_in 'Endereço', with: 'Av Interlagos'
    fill_in 'Número', with: 52
    fill_in 'Bairro', with: 'Interlagos'
    fill_in 'Estado', with: 'SP'
    fill_in 'Cidade', with: 'São Paulo'
    fill_in 'CEP', with: '04661902'
    click_on 'Criar Filial'

    expect(page).to have_content('Filial registrada com sucesso')
    expect(page).to have_content('Interlagos')
    expect(page).to have_content('28179836000114')
  end

  scenario 'and must fill in all fields' do
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Filiais'
    click_on 'Registrar nova filial'
    click_on 'Criar Filial'

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
    visit new_subsidiary_path

    expect(current_path).to eq(new_user_session_path)
  end
end
