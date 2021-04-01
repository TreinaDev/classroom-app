require 'rails_helper'

feature 'Customer see scheduled video class' do
  scenario 'successfully' do
    aluno = create(:customer, token: 'a2w5q8y10ei')

    customer_plan = Plan.new(
      id: 1,
      name: 'Plano Black',
      price: 109.90,
      categories: [
        Category.new(
          id: 1,
          name: 'Bodybuilding'
        ),
        Category.new(
          id: 2,
          name: 'Crossfit'
        )
      ],
      num_classes_available: 30
    )

    time = ActiveSupport::TimeZone.new('Brasilia')
    allow(Time).to receive(:zone) { time }
    allow(time).to receive(:now) { DateTime.parse '2021-03-17 20:30:00.000000000 -0300' }
    allow(Plan).to receive(:find_customer_plans).with('a2w5q8y10ei')
                                                .and_return([customer_plan])
    allow(aluno).to receive(:token).and_return('a2w5q8y10ei')

    crossfit_teacher = create(:user,
                              email: 'crossfit@smartflix.com.br',
                              name: 'João José Silva Santos',
                              password: '123456')
    bodybuilding_teacher = create(:user,
                                  email: 'bodybuilding@smartflix.com.br',
                                  name: 'João Maria Oliveira dos Santos',
                                  password: '654321')

    create(:video_class,
           name: 'CrossFit - Aula inaugural',
           user: crossfit_teacher,
           start_at: '17-03-2021 20:00:00',
           end_at: '17-03-2021 21:30:00',
           category: 'Crossfit')
    create(:video_class,
           name: 'CrossFit - Aula 01',
           user: crossfit_teacher,
           start_at: '18-03-2021 20:00:00',
           end_at: '18-03-2021 21:30:00',
           category: 'Crossfit')
    create(:video_class,
           name: 'Musculacao - Aula inaugural',
           user: bodybuilding_teacher,
           start_at: '17-03-2021 20:00:00',
           end_at: '17-03-2021 21:30:00',
           category: 'Bodybuilding')
    create(:video_class,
           name: 'Musculacao - Aula 01',
           user: bodybuilding_teacher,
           start_at: '18-03-2021 20:00:00',
           end_at: '18-03-2021 21:30:00',
           category: 'Bodybuilding')

    login_as aluno, scope: :customer

    visit root_path
    click_on 'Agenda de Aulas'

    expect(current_path).to eq(scheduled_video_classes_path)
    within('div#Crossfit') do
      expect(page).to have_content('CrossFit - Aula 01')
      expect(page).to have_content(crossfit_teacher.name)
    end
    within('div#Bodybuilding') do
      expect(page).to have_content('Musculacao - Aula 01')
      expect(page).to have_content(bodybuilding_teacher.name)
    end

    within('div#Crossfit') do
      expect(page).not_to have_content('CrossFit - Aula inaugural')
    end
    within('div#Bodybuilding') do
      expect(page).not_to have_content('Musculacao - Aula inaugural')
    end
  end
end
