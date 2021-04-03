require 'rails_helper'

feature 'User views his panel' do
  scenario 'and must be signed in' do
    visit user_root_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, efetue login ou registre-se')
  end

  scenario 'successfully' do
    user = create(:user)
    video_class = create(:video_class, user: user)
    create(:video_class, name: 'Secar barriga',
                         description: 'Aula aeróbica intensa, focada em secar barriga',
                         user: user)
    categories = [
      Category.new(id: 1, name: 'Bodybuilding'),
      Category.new(id: 2, name: 'Crossfit')
    ]
    allow(Category).to receive(:all).and_return(categories)
    allow(Category).to receive(:find_by).with(id: 1).and_return(categories[0])
    allow(Category).to receive(:find_by).with(id: 2).and_return(categories[1])

    login_as user, scope: :user

    visit user_root_path

    expect(page).to have_link video_class.name
    expect(page).to have_content video_class.description
    expect(page).to have_content video_class.category.name
    expect(page).to have_link 'Secar barriga'
    expect(page).to have_content 'Aula aeróbica intensa, focada em secar barriga'
  end

  scenario 'have link to view video class details' do
    user = create(:user)
    video_class = create(:video_class, user: user)
    categories = [
      Category.new(id: 2, name: 'Crossfit'),
      Category.new(id: 1, name: 'Bodybuilding')
    ]
    allow(Category).to receive(:all).and_return(categories)
    allow(Category).to receive(:find_by).with(id: 1).and_return(categories[0])
    allow(Category).to receive(:find_by).with(id: 2).and_return(categories[1])

    login_as user, scope: :user

    visit user_root_path
    click_on video_class.name

    expect(current_path).to eq video_class_path(video_class)
    expect(page).not_to have_link 'Participar da aula'
  end

  scenario 'have link to register new video class' do
    user = create(:user)

    login_as user, scope: :user

    visit user_root_path

    expect(page).to have_link 'Cadastrar aula'
  end
end

feature 'User can edit and disable video class' do
  scenario 'have link to edit' do
    user = create(:user)
    create(:video_class, user: user)
    create(:video_class, name: 'Secar barriga',
                         description: 'Aula aeróbica intensa, focada em secar barriga',
                         user: user)
    categories = [
      Category.new(id: 1, name: 'Bodybuilding'),
      Category.new(id: 2, name: 'Crossfit')
    ]
    allow(Category).to receive(:all).and_return(categories)
    allow(Category).to receive(:find_by).with(id: 1).and_return(categories[0])
    allow(Category).to receive(:find_by).with(id: 2).and_return(categories[1])

    login_as user, scope: :user

    visit user_root_path

    expect(page).to have_link('Editar').twice
  end

  scenario 'have link to disable' do
    user = create(:user)
    create(:video_class, user: user)
    create(:video_class, name: 'Secar barriga',
                         description: 'Aula aeróbica intensa, focada em secar barriga',
                         user: user)
    categories = [
      Category.new(id: 1, name: 'Bodybuilding'),
      Category.new(id: 2, name: 'Crossfit')
    ]
    allow(Category).to receive(:all).and_return(categories)
    allow(Category).to receive(:find_by).with(id: 1).and_return(categories[0])
    allow(Category).to receive(:find_by).with(id: 2).and_return(categories[1])

    login_as user, scope: :user

    visit user_root_path

    expect(page).to have_link('Desabilitar aula').twice
  end
end
