require 'rails_helper'

feature 'Limit access customer' do
  scenario 'if plan limit of video classes is achieve' do
    customer = create(:customer, token: '46465dssafd')
    video_class = create(:video_class, category: 'Yoga')
    WatchedClass.create(customer: customer, video_class: video_class)
    customer_plan = Plan.new(
      id: 1,
      name: 'Básico',
      price: '50',
      categories: [
        Category.new(id: 1, name: 'Yoga'),
        Category.new(id: 2, name: 'FitDance')
      ],
      num_classes_available: 1
    )

    allow(Plan).to receive(:find_customer_plans).with('46465dssafd')
                                                .and_return([customer_plan])

    login_as customer, scope: :customer

    visit video_class_path(video_class)

    expect(current_path).to eq video_class_path(video_class)
    expect(page).to have_content 'Você atingiu o limite de aulas disponíveis no mês'
    expect(page).to have_link 'Turbinar plano'
  end
end
