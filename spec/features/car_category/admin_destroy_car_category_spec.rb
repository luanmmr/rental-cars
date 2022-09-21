require 'rails_helper'

feature 'Admin destroys car category' do
  scenario 'successfully' do
    car_category = create(:car_category)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Categorias'
    within "div#car_category-#{car_category.id}" do
      click_on 'Deletar'
    end

    expect(page).to have_content('Categoria deletada com sucesso')
  end
end
