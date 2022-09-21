require 'rails_helper'

feature 'User sign in' do
  scenario 'successfully' do
    create(:user)

    visit root_path
    click_on 'Entrar'
    within 'form' do
      fill_in 'Email', with: 'user_email@useremail.com.br'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end

    expect(page).to have_content('Login efetuado com sucesso!')
    expect(page).to have_link('Sair')
    expect(page).not_to have_link('Entrar')
    expect(current_path).to eq(root_path)
  end

  scenario 'and logout successfully' do
    User.create!(email: 'test@test.com', password: '123456')

    visit root_path
    within 'form' do
      fill_in 'Email', with: 'test@test.com'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end
    within('li#logout') do
      click_on 'Sair'
    end

    expect(current_path).to eq(new_user_session_path)
  end
end
