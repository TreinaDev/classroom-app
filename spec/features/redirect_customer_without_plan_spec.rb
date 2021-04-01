require 'rails_helper'

feature 'Redirect customer without plan' do
  scenario 'successfully' do
    customer = create(:customer)
    token = JSON.parse(
      File.read(Rails.root.join(
                  'spec/support/apis/get_token.json'
                )), symbolize_names: true
    )
    customer.token = token[:token]
    
    have_plans = customer.customer_plan?(customer.token)


    
  end
end
