require 'rails_helper'

feature 'customer sees next available classes' do
  scenario 'successfully' do
#     resp_json = File.read(Rails.root.join('spec/support/apis/get_plans.json'))
#     resp_double = double('faraday_response', status: 200, body: resp_json)
#     allow(Faraday).to receive(:get).with('smartflix.com.br/api/v1/plans')
#                                    .and_return(resp_double)

#     crossfit_teacher = create(:user,
#                               email: 'crossfit@smartflix.com.br',
#                               name: 'João José Silva Santos')
#     bodybuilding_teacher = create(:user,
#                                   email: 'bodybuilding@smartflix.com.br',
#                                   name: 'João Maria Oliveira dos Santos')

#     create(:video_class,
#            name: 'CrossFit - Aula inaugural',
#            user: crossfit_teacher,
#            start_at: '17-03-2021 20:00:00',
#            end_at: '17-03-2021 21:30:00')
#     create(:video_class,
#            name: 'CrossFit - Aula 01',
#            user: crossfit_teacher,
#            start_at: '18-03-2021 20:00:00',
#            end_at: '18-03-2021 21:30:00')
#     create(:video_class,
#            name: 'Musculacao - Aula inaugural',
#            user: bodybuilding_teacher,
#            start_at: '17-03-2021 20:00:00',
#            end_at: '17-03-2021 21:30:00')
#     create(:video_class,
#            name: 'Musculacao - Aula 01',
#            user: bodybuilding_teacher,
#            start_at: '18-03-2021 20:00:00',
#            end_at: '18-03-2021 21:30:00')

#     aluno = create(:customer)
#     login_as aluno, scope: :customers

#     visit root_path

#     expect(current_path).to eq(root_path)
#     expect(page).to have_content('CrossFit - Aula inaugural')
#     expect(page).to have_content(crossfit_teacher.name)
#     expect(page).to have_content('Musculacao - Aula inaugural')
#     expect(page).to have_content(bodybuilding_teacher.name)

#     expect(page).not_to have_content('CrossFit - Aula 01')
#     expect(page).not_to have_content(crossfit_teacher.name)
#     expect(page).not_to have_content('Musculacao - Aula 01')
#     expect(page).not_to have_content(bodybuilding_teacher.name)
  end
end
