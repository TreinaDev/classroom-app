require 'rails_helper'

feature 'customer register' do
  scenario 'from root_path' do
    visit root_path

    click_on 'Registrar-se'

    expect(current_path).to eq(new_customer_registration_path)
  end

  scenario 'and should register' do
    visit new_customer_registration_path
          
    within('form') do
      fill_in 'E-mail', with: 'guilherme@gmail.com'
      fill_in 'Senha', with:  '123456'
      fill_in 'Confirmar Senha', with: '123456'
      fill_in 'Nome Completo', with: 'Guilherme Marques'
      fill_in 'CPF', with: '1234567-87'
      fill_in 'Idade', with: '40'

      click_on 'Inscrever-se'
    end
    
    expect(current_path).to eq root_path
    expect(Customer.last.email).to eq('guilherme@gmail.com')
    expect(Customer.last.full_name).to eq('Guilherme Marques')
    expect(Customer.last.cpf).to eq('1234567-87')
    expect(Customer.last.age).to eq(40)
  end

  scenario 'and should not allow empty fields' do
    visit new_customer_registration_path
          
    within('form') do
      fill_in 'E-mail', with: 'guilherme@gmail.com'
      fill_in 'Senha', with:  '123456'
      fill_in 'Confirmar Senha', with: '123456'
      fill_in 'Nome Completo', with: ''
      fill_in 'CPF', with: ''
      fill_in 'Idade', with: ''

      click_on 'Inscrever-se'
    end
    
    expect(current_path).to eq customer_registration_path
    expect(page).to have_content('Nome Completo não pode ficar em branco')
    expect(page).to have_content('CPF não pode ficar em branco')
    expect(page).to have_content('Idade não pode ficar em branco')
    expect(Customer.last).to eq(nil)
  end
end