require 'rails_helper'

feature 'User sign up' do
  scenario 'successfully' do
    visit root_path
    click_on 'Registrar-se'

    within('form') do 
      fill_in 'Nome Completo', with: 'Milena Ferreira'
      fill_in 'E-mail', with: 'milena@smartflix.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirme sua senha', with: '123456'
      click_on 'Registrar-se'
    end

    expect(page).to have_content 'milena@smartflix.com.br'
    expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso.'
  end
end