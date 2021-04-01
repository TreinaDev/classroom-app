require 'rails_helper'

feature 'User create new video class' do
  scenario 'and must be signed in' do
    create(:user)

    view_context = instance_double(ActionView::Base)
    some_custom_path = '/'
    allow(view_context).to receive(:view_renderer).and_return(some_custom_path)

    visit user_root_path

    expect(current_path).to eq new_user_session_path
  end

  scenario 'successfully' do
    user = create(:user)

    categories = [
      Category.new(id: 1, name: 'Zumba'),
      Category.new(id: 2, name: 'Yoga'),
      Category.new(id: 3, name: 'Bodybuilding'),
      Category.new(id: 4, name: 'Crossfit')
    ]

    allow(Category).to receive(:all).and_return(categories)

    login_as user, scope: :user

    visit user_root_path
    click_on 'Cadastrar aula'

    within 'form' do
      fill_in 'Nome', with: 'Aula Yoga'
      fill_in 'Descrição', with: 'Aula curta sobre alongamento'
      fill_in 'Endereço URL da Aula', with: 'http://www.smartflix.com.br/aula/aula-yoga'
      fill_in 'Data de Início', with: '17-03-2021 20:00:00'
      fill_in 'Data de Fim', with: '17-03-2021 21:30:00'
      page.select 'Yoga', from: 'Categoria'
      click_on 'Criar aula'
    end

    video_class = VideoClass.last
    expect(current_path).to eq(video_class_path(video_class))
    expect(page).to have_content('Aula Yoga')
    expect(page).to have_content('Aula curta sobre alongamento')
    expect(page).to have_content('Horário 20:00 - 21:30')
    expect(page).to have_content('Data de Início 17/03/2021')
    expect(page).to have_content('http://www.smartflix.com.br/aula/aula-yoga')
  end

  scenario 'and see messages if errors' do
    user = create(:user)

    categories = [
      Category.new(id: 1, name: 'Zumba'),
      Category.new(id: 2, name: 'Yoga'),
      Category.new(id: 3, name: 'Bodybuilding'),
      Category.new(id: 4, name: 'Crossfit')
    ]

    allow(Category).to receive(:all).and_return(categories)

    login_as user, scope: :user

    visit user_root_path
    click_on 'Cadastrar aula'

    within 'form' do
      fill_in 'Nome', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Endereço URL da Aula', with: ''
      fill_in 'Data de Início', with: ''
      fill_in 'Data de Fim', with: ''
      click_on 'Criar aula'
    end

    expect(page).to have_content('Não foi possível criar a aula')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Descrição não pode ficar em branco')
    expect(page).to have_content('Data de Início não pode ficar em branco')
    expect(page).to have_content('Data de Fim não pode ficar em branco')
    expect(page).to have_content('Categoria não pode ficar em branco')
  end
end

feature 'User edit video class' do
  scenario 'have link' do
    user = create(:user)
    create(:video_class, user: user)
    categories = [
      Category.new(id: 1, name: 'Bodybuilding'),
      Category.new(id: 2, name: 'Crossfit')
    ]
    allow(Category).to receive(:all).and_return(categories)

    login_as user, scope: :user

    visit user_root_path

    expect(page).to have_link('Editar')
  end

  scenario 'successfully' do
    user = create(:user)
    video_class = create(:video_class, user: user)
    categories = [
      Category.new(id: 1, name: 'Zumba'),
      Category.new(id: 2, name: 'Yoga'),
      Category.new(id: 3, name: 'Bodybuilding'),
      Category.new(id: 4, name: 'Crossfit')
    ]

    allow(Category).to receive(:all).and_return(categories)

    login_as user, scope: :user

    visit user_root_path
    click_on 'Editar'

    within 'form' do
      fill_in 'Nome', with: 'Aula Yoga'
      fill_in 'Descrição', with: 'Aula curta sobre alongamento'
      fill_in 'Endereço URL da Aula', with: 'http://www.smartflix.com.br/aula/aula-yoga'
      fill_in 'Data de Início', with: '17-03-2021 20:00:00'
      fill_in 'Data de Fim', with: '27-03-2021 20:00:00'
      page.select 'Zumba', from: 'Categoria'
      click_on 'Editar aula'
    end

    expect(current_path).to eq(video_class_path(video_class))
    expect(page).to have_content('Aula Yoga')
    expect(page).to have_content('Aula curta sobre alongamento')
    expect(page).to have_content('http://www.smartflix.com.br/aula/aula-yoga')
  end

  scenario 'and see messages if errors' do
    user = create(:user)
    create(:video_class, user: user)
    categories = [
      Category.new(id: 1, name: 'Zumba'),
      Category.new(id: 2, name: 'Yoga'),
      Category.new(id: 3, name: 'Bodybuilding'),
      Category.new(id: 4, name: 'Crossfit')
    ]

    allow(Category).to receive(:all).and_return(categories)

    login_as user, scope: :user

    visit user_root_path
    click_on 'Editar'

    within 'form' do
      fill_in 'Nome', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Endereço URL da Aula', with: ''
      fill_in 'Data de Início', with: ''
      fill_in 'Data de Fim', with: ''
      click_on 'Editar aula'
    end

    expect(page).to have_content('Não foi possível editar a aula')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Descrição não pode ficar em branco')
  end
end

feature 'User can delete video class' do
  scenario 'have link' do
    user = create(:user)
    create(:video_class, user: user)
    categories = [
      Category.new(id: 1, name: 'Bodybuilding'),
      Category.new(id: 2, name: 'Crossfit')
    ]
    allow(Category).to receive(:all).and_return(categories)

    login_as user, scope: :user

    visit user_root_path

    expect(page).to have_link('Apagar aula')
  end

  scenario 'successfully' do
    user = create(:user)
    video_class = create(:video_class, user: user)
    categories = [
      Category.new(id: 1, name: 'Bodybuilding'),
      Category.new(id: 2, name: 'Crossfit')
    ]
    allow(Category).to receive(:all).and_return(categories)

    login_as user, scope: :user

    visit user_root_path
    click_on 'Apagar aula'

    expect(page).to have_content 'Aula apagada com sucesso!'
    expect(page).not_to have_link video_class.name
  end
end
