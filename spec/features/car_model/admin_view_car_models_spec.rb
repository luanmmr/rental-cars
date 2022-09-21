require 'rails_helper'

feature 'Admin view Car Models' do
  scenario 'successfully' do
    create(:car_model)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Carros'
    click_on 'Modelos'

    expect(page).to have_content('Fiat')
    expect(page).to have_content('Uno')
    expect(page).to have_content('2018')
    expect(page).to have_content('Flex')
    expect(page).to have_content('X')
    expect(page).to have_content('1.8')
  end

  scenario 'and return to home page' do
    create(:car_model)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Carros'
    click_on 'Modelos'
    click_on 'Home Page'

    expect(current_path).to eq root_path
  end
end
