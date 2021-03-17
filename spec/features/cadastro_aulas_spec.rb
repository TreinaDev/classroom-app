require 'rails_helper'

feature 'User create new video class' do
  scenario 'successfully' do
    user = create(:user)

    login_as user, scope: :user

    visit user_path(user)
    click_on 'Adicionar Aula'

    within 'form' do
      fill_in 'Nome', with: 'Aula Yoga'
      fill_in 'Descrição', with: 'Aula curta sobre alongamento'
      fill_in 'Endereço URL', with: 'www.smartflix.com.br/aula/aula-yoga'
      fill_in 'Data de início', with: DateTime.now
      fill_in 'Data de fim', with: 10.days.since(DateTime.now)
      click_on 'Criar vídeo'
    end

    video_class = VideoClass.last
    expect(current_path).to eq(video_class_path(video_class))
    expect(page).to have_content('Aula Yoga')
    expect(page).to have_content('Aula curta sobre alongamento')
    expect(page).to have_content('www.smartflix.com.br/aula/aula-yoga')
  end
end