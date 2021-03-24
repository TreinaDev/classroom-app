require 'rails_helper'

feature 'Customer views video class details' do
  scenario 'must be signed in' do
    allow(Plan).to receive(:all).and_return([])
    video_class = create(:video_class)

    visit video_class_path(video_class)

    expect(current_path).to eq root_path
    expect(page).to have_content("Você precisa estar logado")
  end

  scenario 'successfully' do
    customer = create(:customer)
    video_class = create(:video_class)

    allow(Plan).to receive(:find_customer_plan).and_return([])

    login_as customer, scope: :customer

    visit video_class_path(video_class)

    expect(page).to have_content video_class.name
    expect(page).to have_content video_class.description
    expect(page).to have_content video_class.user.name
    expect(page).to have_content video_class.category
    expect(page).to have_content '18:08 - 18:58'
    expect(page).to have_content '16/04/2021'
    #Adicionar categoria
  end

  scenario 'must have plan' do
    customer = create(:customer)
    video_class = create(:video_class)
    customer_plan = Plan.new(name: 'Básico', price: '50', categories: [1,2], num_classes_available: 5)

    allow_any_instance_of(Customer).to receive(:token).and_return('46465dssafd')
    allow(Plan).to receive(:find_customer_plan).with('46465dssafd').and_return(customer_plan)

    login_as customer, scope: :customer

    visit video_class_path(video_class)

    expect(page).to have_link 'Participar da aula'
  end


  # scenario 'have link to attend the class' do
  #   customer = create(:customer)
  #   video_class = create(:video_class)

  #   login_as customer, scope: :customer

  #   visit video_class_path(video_class)
    
  #   expect(page).to have_link 'Participar da aula'
  # end
end