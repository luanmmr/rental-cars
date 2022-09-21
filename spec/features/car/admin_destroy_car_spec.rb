require 'rails_helper'

feature 'Admin destroys car' do
  scenario 'successfully' do
    user = create(:user)
    car = create(:car)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Carros'
    within "td#car-#{car.id}" do
      click_on 'Deletar'
    end

    expect(page).to have_content('Carro deletado com sucesso')
  end
end
