require 'rails_helper'

feature 'Admin destroys car model' do
  scenario 'successfully' do
    car_model = create(:car_model)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Carros'
    click_on 'Modelos'
    within "td#car_model-#{car_model.id}" do
      click_on 'Deletar'
    end

    expect(page).to have_content('Modelo deletado com sucesso')
  end
end
