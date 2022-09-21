require 'rails_helper'

feature 'Admin view subsidiaries' do
  scenario 'successfully' do
    user = create(:user)
    create(:subsidiary)
    create(:subsidiary, name: 'Aracatuba', cnpj: '10792229000160',
                        zip_code: '16102285', address: 'Av. dos Araçás')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Filiais'

    expect(page).to have_content('Carrefour Giovanni Gronchi')
    expect(page).to have_content('41298631000116')
    expect(page).to have_content('Aracatuba')
    expect(page).to have_content('10792229000160')
  end

  scenario 'and access details of subsidiary' do
    create(:car)
    user = create(:user)

    login_as user, scope: :user
    visit root_path
    click_on 'Filiais'
    click_on 'Carrefour Giovanni Gronchi'

    expect(page).to have_content('Carrefour Giovanni Gronchi')
    expect(page).to have_content('RBY1995')
  end

  scenario 'and return to home page' do
    create(:subsidiary)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Filiais'
    click_on 'Carrefour Giovanni Gronchi'
    click_on 'Home Page'

    expect(current_path).to eq root_path
  end

  scenario 'and must be authenticated' do
    visit subsidiaries_path

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'and must be authenticated for more view show' do
    visit subsidiary_path(7)

    expect(current_path).to eq(new_user_session_path)
  end
end
