require 'rails_helper'

feature 'Admin destroys client' do
  scenario 'successfully' do
    client = create(:client)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Clientes'
    within "div#client-#{client.id}" do
      click_on 'Deletar'
    end

    expect(page).to have_content('Cliente deletado com sucesso')
  end
end
