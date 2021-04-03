require 'rails_helper'

feature 'customer register' do
  scenario 'from root_path' do
    payments_json = File.read(Rails.root.join('spec/support/apis/payment_methods.json'))
    payments_double = double('faraday_response', status: 200, body: payments_json)

    plans_json = File.read(Rails.root.join('spec/support/apis/get_plans.json'))
    plans_double = double('faraday_response', status: 200, body: plans_json)

    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['payments_url']}/payment_methods")
                                   .and_return(payments_double)

    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['enrollments_url']}/plans")
                                   .and_return(plans_double)
    visit root_path

    click_on 'Alunos'

    expect(current_path).to eq(new_customer_registration_path)
  end

  scenario 'and redirect to enrollment' do
    payment_methods_json = File.read(Rails.root.join('spec/support/apis/payment_methods.json'))
    get_payment_methods_double = double('faraday_response', status: 200, body: payment_methods_json)

    plans_json = File.read(Rails.root.join('spec/support/apis/get_plans.json'))
    get_plans_double = double('faraday_response', status: 200, body: plans_json)

    resp_customer_plan_double = double('faraday_response',
                                        status: 404,
                                        body: '{"msg":"Token não encontrado"}')

    token_json = File.read(Rails.root.join('spec/support/apis/get_token.json'))
    post_token_double = double('faraday_response', status: 201, body: token_json)
    token_hash = JSON.parse(token_json, symbolize_names: true)

    allow(Faraday).to receive(:get)
      .with("#{Rails.configuration.external_apis['payments_url']}/payment_methods")
      .and_return(get_payment_methods_double)

    allow(Faraday).to receive(:get)
      .with("#{Rails.configuration.external_apis['enrollments_url']}/plans")
      .and_return(get_plans_double)

    allow(Faraday).to receive(:get)
      .with(
        "#{Rails.configuration.external_apis['enrollments_url']}" \
        "/enrollments/#{token_hash[:token]}"
      )
      .and_return(resp_customer_plan_double)

    allow(Faraday).to receive(:get)
      .with('http://localhost:4000', {'Accept' => 'application/html'})

    allow(Faraday).to receive(:post)
      .with(
        "#{Rails.configuration.external_apis['enrollments_url']}/enrollments",
        { full_name: 'Guilherme Marques',
          cpf: '300.119.400-45',
          birth_date: '1983-11-25',
          email: 'guilherme@gmail.com',
          payment_methods: 1 }.to_json,
        'Content-Type' => 'application/json'
      )
      .and_return(post_token_double)

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

    expect(current_path).to eq Rails.configuration.external_apis[:choose_plan_url]
  end

  scenario 'and should not allow empty fields' do
    resp_json = File.read(Rails.root.join('spec/support/apis/payment_methods.json'))
    get_resp_double = double('faraday_response', status: 200, body: resp_json)

    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['payments_url']}/payment_methods")
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
    expect(page).to have_content('Data de Nascimento não pode ficar em branco')
    expect(Customer.last).to eq(nil)
  end
end
