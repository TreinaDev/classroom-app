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

    login_as customer

    visit video_class_path(video_class)

    expect(page).to have_content video_class.name
    expect(page).to have_content video_class.description
    expect(page).to have_content video_class.user.name
    expect(page).to have_content '18:08 - 18:58'
    expect(page).to have_content '16/04/2021'
    #expect(page).to have_content video_class.video_url
    #Adicionar categoria
  end

  scenario 'have link to attend the class' do
    customer = create(:customer)
    video_class = create(:video_class)

    login_as customer

    visit video_class_path(video_class)

    expect(page).to have_link 'Participar da aula'
  end

  scenario 'must have plan and class available' do
  end

    #   scenario 'customer attends class' do
    #   allow(Plan).to receive(:all).and_return([])
    #   customer = create(:customer)
    #   video_class = create(:video_class)
  
    #   login_as customer
  
    #   visit video_class_path(video_class)
    #   click_on 'Participar da aula'
  
    #   #expect(page).to have_content ('Tem certeza que deseja participar?')
    #   expect(current_path).to eq (video_class.video_url)
    # end
  
end