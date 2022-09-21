require 'rails_helper'

feature 'Admin destroys subsidiary' do
  scenario 'successfully' do
    subsidiary = create(:subsidiary)
    user = create(:user)

    login_as(user, scope: :user)
    visit subsidiaries_path
    within "div#subsidiary-#{subsidiary.id}" do
      click_on 'Deletar'
    end

    expect(page).to have_content('Filial deletada com sucesso')
  end
end
