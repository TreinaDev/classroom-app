require 'rails_helper'

feature 'customer sees next available classes' do
  scenario 'successfully' do
    customer_plan = Plan.new(
      name: 'Plano Black',
      price: 109.90,
      categories: [
        {
          name: 'Bodybuilding'
        },
        {
          name: 'Crossfit'
        }
      ]
    )

    # TODO: pesquisar sobre como fazer o mock de um método não implementado
    allow(Plan).to receive(:find_by).with('a2w5q8y10ei')
                                    .and_return(customer_plan)

    crossfit_teacher = create(:user,
                              email: 'crossfit@smartflix.com.br',
                              name: 'João José Silva Santos')
    bodybuilding_teacher = create(:user,
                                  email: 'bodybuilding@smartflix.com.br',
                                  name: 'João Maria Oliveira dos Santos')

    create(:video_class,
           name: 'CrossFit - Aula inaugural',
           user: crossfit_teacher,
           start_at: '17-03-2021 20:00:00',
           end_at: '27-03-2021 20:00:00',
           category: 'Crossfit')
    create(:video_class,
           name: 'CrossFit - Aula 01',
           user: crossfit_teacher,
           start_at: '18-03-2021 20:00:00',
           end_at: '28-03-2021 20:00:00',
           category: 'Crossfit')
    create(:video_class,
           name: 'Musculacao - Aula inaugural',
           user: bodybuilding_teacher,
           start_at: '17-03-2021 20:00:00',
           end_at: '27-03-2021 20:00:00',
           category: 'Bodybuilding')
    create(:video_class,
           name: 'Musculacao - Aula 01',
           user: bodybuilding_teacher,
           start_at: '18-03-2021 20:00:00',
           end_at: '28-03-2021 20:00:00',
           category: 'Bodybuilding')

    aluno = create(:customer)
    login_as aluno, scope: :customer

    visit root_path

    expect(current_path).to eq(root_path)
    expect(page).to have_content('CrossFit - Aula inaugural')
    expect(page).to have_content(crossfit_teacher.name)
    expect(page).to have_content('Musculacao - Aula inaugural')
    expect(page).to have_content(bodybuilding_teacher.name)

    expect(page).not_to have_content('CrossFit - Aula 01')
    expect(page).not_to have_content(crossfit_teacher.name)
    expect(page).not_to have_content('Musculacao - Aula 01')
    expect(page).not_to have_content(bodybuilding_teacher.name)

    expect(page).not_to have_link('Contratar')
  end
end
