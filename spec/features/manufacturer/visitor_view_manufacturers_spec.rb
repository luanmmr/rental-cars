require 'rails_helper'

feature 'Visitor view manufacturers' do
  scenario 'successfully' do
    # Testes de três estados - AAA
    # Arrange - Criar dados
    create(:manufacturer)
    create(:manufacturer, name: 'Volkswagen')
    user = create(:user)

    # Act - Executar ações
    login_as(user, scope: :user)
    visit root_path
    click_on 'Carros'
    click_on 'Fabricantes'

    # Assert - Verificar coisas
    expect(page).to have_content('Fiat')
    expect(page).to have_content('Volkswagen')
  end

  scenario 'and return to home page' do
    create(:manufacturer)
    create(:manufacturer, name: 'Volkswagen')
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Carros'
    click_on 'Fabricantes'
    click_on 'Home Page'

    expect(current_path).to eq root_path
  end
end
