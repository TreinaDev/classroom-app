require 'rails_helper'

feature 'User sign up' do
  scenario 'successfully' do
    allow(Plan).to receive(:all).and_return([])

    visit root_path
    click_on 'Acesso Professor'
    click_on 'Registrar-se'

    within('form') do
      fill_in 'Nome', with: 'Milena Ferreira'
      attach_file 'Foto', Rails.root.join('spec/support/foto_professor.jpg')
      fill_in 'E-mail', with: 'milena@smartflix.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirme sua senha', with: '123456'
      click_on 'Registrar-se'
    end

    expect(current_path).to eq user_root_path
    expect(page).to have_content 'Milena Ferreira'
    expect(User.last.photo.attached?).to eq true
    expect(page).to have_content 'Login efetuado com sucesso. Se não foi autorizado,'\
                                  ' a confirmação será enviada por e-mail'
  end

  scenario 'attributes cannot be blank' do
    allow(Plan).to receive(:all).and_return([])

    visit root_path
    click_on 'Acesso Professor'
    click_on 'Registrar-se'

    within('form') do
      fill_in 'Nome', with: ''
      fill_in 'E-mail', with: ''
      fill_in 'Senha', with: ''
      fill_in 'Confirme sua senha', with: ''
      click_on 'Registrar-se'
    end

    expect(page).to have_content 'Não foi possível salvar professor'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
  end

  scenario 'domain must be @smartflix.com.br' do
    allow(Plan).to receive(:all).and_return([])

    visit root_path
    click_on 'Acesso Professor'
    click_on 'Registrar-se'

    within('form') do
      fill_in 'Nome', with: 'Milena Ferreira'
      fill_in 'E-mail', with: 'milena@mail.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirme sua senha', with: '123456'
      click_on 'Registrar-se'
    end

    expect(page).to have_content 'Não foi possível salvar professor'
    expect(page).to have_content 'E-mail precisa ser da empresa SmartFlix'
  end
end

feature 'User sign in' do
  scenario 'successfully' do
    allow(Plan).to receive(:all).and_return([])

    user = create(:user)

    visit root_path
    click_on 'Acesso Professor'

    within('form') do
      fill_in 'E-mail', with: user.email
      fill_in 'Senha', with: 'professor123'
      click_on 'Entrar'
    end

    expect(current_path).to eq user_root_path
    expect(page).to have_content 'Login efetuado com sucesso'
    expect(page).to have_content user.name
    expect(page).not_to have_link 'Acesso Professor'
  end

  scenario 'and logout' do
    allow(Plan).to receive(:all).and_return([])

    user = create(:user)

    login_as user

    visit root_path
    click_on 'Sair'

    expect(page).not_to have_link('Sair')
    expect(page).not_to have_content(user.email)
    expect(page).to have_link 'Acesso Professor'
  end
end
