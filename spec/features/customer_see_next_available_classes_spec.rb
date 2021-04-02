require 'rails_helper'

feature 'customer sees next available classes' do
  scenario 'successfully' do
    aluno = create(:customer, token: 'a2w5q8y10ei')
    categories = [
      Category.new(id: 1, name: 'Bodybuilding'),
      Category.new(id: 2, name: 'Crossfit')
    ]

    customer_plan = Plan.new(id: 1, name: 'Plano Black',
                             monthly_rate: 109.90,
                             monthly_class_limit: 30,
                             description: 'Para aqueles que querem entrar em forma',
                             status: 'active',
                             class_categories: categories)

    time = ActiveSupport::TimeZone.new('Brasilia')
    allow(Time).to receive(:zone) { time }
    allow(time).to receive(:now) { DateTime.parse '2021-03-17 20:30:00.000000000 -0300' }
    allow(Plan).to receive(:all).and_return([])
    allow(Enrollment).to receive(:find_customer_plan).with('a2w5q8y10ei')
                                                     .and_return(customer_plan)
    allow(Category).to receive(:all).and_return(categories)
    allow(Category).to receive(:find_by).with(id: 1).and_return(categories[0])
    allow(Category).to receive(:find_by).with(id: 2).and_return(categories[1])

    allow(aluno).to receive(:token).and_return('a2w5q8y10ei')

    crossfit_teacher = create(:user,
                              email: 'crossfit@smartflix.com.br',
                              name: 'João José Silva Santos',
                              password: '123456')
    bodybuilding_teacher = create(:user,
                                  email: 'bodybuilding@smartflix.com.br',
                                  name: 'João Maria Oliveira dos Santos',
                                  password: '654321')

    crossfit01 = create(:video_class,
                        name: 'CrossFit - Aula inaugural',
                        user: crossfit_teacher,
                        start_at: '17-03-2021 20:00:00',
                        end_at: '17-03-2021 21:30:00',
                        category_id: 2)
    crossfit02 = create(:video_class,
                        name: 'CrossFit - Aula 01',
                        user: crossfit_teacher,
                        start_at: '18-03-2021 20:00:00',
                        end_at: '18-03-2021 21:30:00',
                        category_id: 2)
    bodybuilding01 = create(:video_class,
                            name: 'Musculacao - Aula inaugural',
                            user: bodybuilding_teacher,
                            start_at: '17-03-2021 20:00:00',
                            end_at: '17-03-2021 21:30:00',
                            category_id: 1)
    bodybuilding02 = create(:video_class,
                            name: 'Musculacao - Aula 01',
                            user: bodybuilding_teacher,
                            start_at: '18-03-2021 20:00:00',
                            end_at: '18-03-2021 21:30:00',
                            category_id: 1)

    login_as aluno, scope: :customer

    visit root_path

    expect(current_path).to eq(root_path)
    within("div\##{crossfit01.category.name}#{crossfit01.id}") do
      expect(page).to have_content('CrossFit - Aula inaugural')
      expect(page).to have_content(crossfit_teacher.name)
    end
    within("div\##{bodybuilding01.category.name}#{bodybuilding01.id}") do
      expect(page).to have_content('Musculacao - Aula inaugural')
      expect(page).to have_content(bodybuilding_teacher.name)
    end

    expect(html).not_to have_selector("div\##{crossfit02.category.name}#{crossfit02.id}")
    expect(html).not_to have_selector("div\##{bodybuilding02.category.name}#{bodybuilding02.id}")
    expect(page).not_to have_content('CrossFit - Aula 01')
    expect(page).not_to have_content('Musculacao - Aula 01')

    expect(page).not_to have_link('Contratar')
  end
end
