require 'rails_helper'

feature 'customer register' do
  scenario 'from root_path' do
    payments_json = File.read(Rails.root.join('spec/support/apis/payment_methods.json'))
    payments_double = double('faraday_response', status: 200, body: payments_json)

    plans_json = File.read(Rails.root.join('spec/support/apis/get_plans.json'))
    plans_double = double('faraday_response', status: 200, body: plans_json)

    allow(Faraday).to receive(:get).with(Rails.configuration.url['payments_url'])
                                   .and_return(payments_double)

    allow(Faraday).to receive(:get).with('smartflix.com.br/api/v1/plans')
                                   .and_return(plans_double)
    visit root_path

    click_on 'Alunos'

    expect(current_path).to eq(new_customer_registration_path)
  end

  scenario 'successfully' do
    resp_json = File.read(Rails.root.join('spec/support/apis/payment_methods.json'))
    get_resp_double = double('faraday_response', status: 200, body: resp_json)

    plans_json = File.read(Rails.root.join('spec/support/apis/get_plans.json'))
    plans_double = double('faraday_response', status: 200, body: plans_json)

    resp_customer_plans_json = File.read(Rails.root.join('spec/support/apis/get_user_plans.json'))
    resp_customer_plans_double = double('faraday_response', status: 200, body: resp_customer_plans_json)

    post_resp_double = double('faraday_response', status: 201, body: 'a2w5q8y10ei')

    allow(Faraday).to receive(:get).with(Rails.configuration.url['payments_url'])
                                   .and_return(get_resp_double)

    allow(Faraday).to receive(:get).with('smartflix.com.br/api/v1/plans')
                                   .and_return(plans_double)

    allow(Faraday).to receive(:get).with('smartflix.com.br/api/v1/enrollment/a2w5q8y10ei/plans')
                                   .and_return(resp_customer_plans_double)

    allow(Faraday).to receive(:post).with(Rails.configuration.url['customers_enrollment_url'],
                                          { full_name: 'Guilherme Marques',
                                            email: 'guilherme@gmail.com',
                                            cpf: '300.119.400-45',
                                            birth_date: '1983-11-25',
                                            payment_methods: 1 }.to_json,
                                          'Content-Type' => 'application/json')
                                    .and_return(post_resp_double)

    visit new_customer_registration_path

    within('form') do
      fill_in 'E-mail', with: 'guilherme@gmail.com'
      fill_in 'Senha', with:  '123456'
      fill_in 'Confirmar Senha', with: '123456'
      fill_in 'Nome Completo', with: 'Guilherme Marques'
      fill_in 'CPF', with: '300.119.400-45'
      fill_in 'Idade', with: '37'
      fill_in 'Data de Nascimento', with: '25/11/1983'
      find(:css, "#customer_payment_methods_1[value='1']").set(true)

      click_on 'Inscrever-se'
    end

    expect(current_path).to eq root_path
    expect(Customer.last.email).to eq('guilherme@gmail.com')
    expect(Customer.last.full_name).to eq('Guilherme Marques')
    expect(Customer.last.cpf).to eq('300.119.400-45')
    expect(Customer.last.age).to eq(37)
  end

  scenario 'and should not allow empty fields' do
    resp_json = File.read(Rails.root.join('spec/support/apis/payment_methods.json'))
    get_resp_double = double('faraday_response', status: 200, body: resp_json)

    allow(Faraday).to receive(:get).with(Rails.configuration.url['payments_url'])
                                   .and_return(get_resp_double)

    visit new_customer_registration_path

    within('form') do
      fill_in 'E-mail', with: 'guilherme@gmail.com'
      fill_in 'Senha', with:  '123456'
      fill_in 'Confirmar Senha', with: '123456'
      fill_in 'Nome Completo', with: ''
      fill_in 'CPF', with: ''
      fill_in 'Idade', with: ''
      fill_in 'Data de Nascimento', with: ''
      find(:css, "#customer_payment_methods_1[value='1']").set(true)

      click_on 'Inscrever-se'
    end

    expect(page).to have_content('Nome Completo não pode ficar em branco')
    expect(page).to have_content('CPF não pode ficar em branco')
    expect(page).to have_content('Idade não pode ficar em branco')
    expect(Customer.last).to eq(nil)
  end
end
