require 'rails_helper'

feature 'Visitor visits home page' do
  scenario 'And sees subscription plans options' do
    resp_json = File.read(Rails.root.join('spec/support/apis/get_plans.json'))
    resp_double = double('faraday_response', status: 200, body: resp_json )

    allow(Faraday).to receive(:get).with('smartflix.com.br/api/v1/plans')
                                   .and_return(resp_double)

    visit root_path

    expect(page).to have_content('Smartflix')
    expect(page).to have_content('Escolha seu plano')

    expect(page).to have_content('Plano Smart')
    expect(page).to have_content('R$ 69,90')
    expect(page).to have_content('Plano Black')
    expect(page).to have_content('R$ 109,90')
    expect(page).to have_link('Contratar')
  end
end