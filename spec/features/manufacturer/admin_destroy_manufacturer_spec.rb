require 'rails_helper'

feature 'Admin destroys manufacturer' do
  scenario 'successfully' do
    create(:manufacturer)
    user = create(:user)

    login_as(user, scope: :user)
    visit cars_path
    click_on 'Fabricantes'
    click_on 'Deletar'

    expect(page).to have_content('Fabricante deletada com sucesso')
  end
end
