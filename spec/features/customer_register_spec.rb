require 'rails_helper'

feature 'customer register' do
  scenario 'from root_path' do
    resp_json = File.read(Rails.root.join('spec/support/apis/payment_methods.json'))
    resp_double = double('faraday_response', status: 200, body: resp_json)

    allow(Faraday).to receive(:get).with('smartflix.com.br/api/v1/payments')
                                     .and_return(resp_double)
    visit root_path

    click_on 'Alunos'

    expect(current_path).to eq(new_customer_registration_path)
  end

  scenario 'successfully' do
    resp_json = File.read(Rails.root.join('spec/support/apis/payment_methods.json'))
    get_resp_double = double('faraday_response', status: 200, body: resp_json)

    allow(Faraday).to receive(:get).with('smartflix.com.br/api/v1/payments')
                                     .and_return(get_resp_double)
    
    post_resp_double = double('faraday_response', status: 201, body: 'token_retornado')

    allow(Faraday).to receive(:post).with('smartflix.com.br/api/v1/enrollments',
                                         { full_name: 'Guilherme Marques',
                                           email: 'guilherme@gmail.com' }.to_json,
                                         "Content-Type" => "application/json")
                                    .and_return(post_resp_double)
    
    visit new_customer_registration_path
          
    within('form') do
      fill_in 'E-mail', with: 'guilherme@gmail.com'
      fill_in 'Senha', with:  '123456'
      fill_in 'Confirmar Senha', with: '123456'
      fill_in 'Nome Completo', with: 'Guilherme Marques'
      fill_in 'CPF', with: '1234567-87'
      fill_in 'Idade', with: '40'
      page.select 'Pix', from: 'Formas de Pagamento'

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