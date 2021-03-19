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
    expect(page).to have_content video_class.video_url
    #Adicionar duracao da aula, professor, horário e categoria
  end

  # scenario 'have link to watch the class' do
  # end
end