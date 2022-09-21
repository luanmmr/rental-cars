require 'rails_helper'

feature 'Admin edit client' do
  scenario 'successfully' do
    client = create(:client)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Clientes'
    within "div#client-#{client.id}" do
      click_on 'Editar'
    end
    fill_in 'Nome', with: 'Maria'
    fill_in 'Email', with: 'maria@hotmail.com'
    fill_in 'CPF', with: '49582428151'
    click_on 'Atualizar Cliente'

    expect(page).to have_content('Cliente atualizado com sucesso')
    expect(page).to have_content('Maria')
    expect(page).to have_content('maria@hotmail.com')
    expect(page).to have_content('49582428151')
  end

  scenario 'and must fill in all fields' do
    client = create(:client)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Clientes'
    within "div#client-#{client.id}" do
      click_on 'Editar'
    end
    fill_in 'Nome', with: ''
    fill_in 'Email', with: ''
    fill_in 'CPF', with: ''
    click_on 'Atualizar Cliente'

    expect(page).to have_content('Email não pode ficar em branco')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('CPF não pode ficar em branco')
    expect(page).to_not have_content('Cliente atualizado com sucesso')
  end

  scenario 'and cpf must be unique' do
    client = create(:client)
    create(:client, document: '14498169112', email: 'abraao@hotmail.com')
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Clientes'
    within "div#client-#{client.id}" do
      click_on 'Editar'
    end
    fill_in 'CPF', with: '14498169112'
    click_on 'Atualizar Cliente'

    expect(page).to have_content('Você deve corrigir os seguintes erros para '\
                                 'continuar')
    expect(page).to have_content('CPF já está em uso')
    expect(page).to_not have_content('Cliente atualizado com sucesso')
  end

  scenario 'and name must to have only words' do
    user = User.create!(email: 'teste@hotmail.com', password: '123456')
    client = Client.create(name: 'Jose', document: '25498763123',
                           email: 'jose@jose.com.br')

    login_as(user, scope: :user)
    visit edit_client_path(client)
    fill_in 'Nome', with: 'P3dr0 5ilva'
    click_on 'Atualizar Cliente'

    expect(page).to have_content('Nome não é válido')
    expect(page).to_not have_content('Cliente atualizado com sucesso')
  end

  scenario 'and cpf must have only numbers' do
    user = User.create!(email: 'teste@hotmail.com', password: '123456')
    client = Client.create(name: 'Jose', document: '25498763123',
                           email: 'jose@jose.com.br')

    login_as(user, scope: :user)
    visit edit_client_path(client)
    fill_in 'CPF', with: 'testetestet'
    click_on 'Atualizar Cliente'

    expect(page).to have_content('CPF não é um número')
  end

  scenario 'and must be authenticated' do
    visit edit_client_path(7)

    expect(current_path).to eq(new_user_session_path)
  end
end
