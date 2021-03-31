require 'rails_helper'

feature 'Customer views video class details' do
  scenario 'must be signed in' do
    allow(Plan).to receive(:all).and_return([])
    video_class = create(:video_class)

    visit video_class_path(video_class)

    expect(current_path).to eq root_path
    expect(page).to have_content('Você precisa estar logado')
  end

  scenario 'successfully' do
    customer = create(:customer, token: '46465dssafd')
    video_class = create(:video_class, start_at: '2021-04-16 18:08:04',
                                       end_at: '2021-04-16 18:58:04', category: 'Musculação')

    allow(Plan).to receive(:find_customer_plans).with('46465dssafd').and_return([])

    login_as customer, scope: :customer

    visit video_class_path(video_class)

    expect(page).to have_content video_class.name
    expect(page).to have_content video_class.description
    expect(page).to have_content video_class.user.name
    expect(page).to have_content video_class.category
    expect(page).to have_content '18:08 - 18:58'
    expect(page).to have_content '16/04/2021'
  end

  scenario 'must have plan and category allowed' do
    customer = create(:customer, token: '46465dssafd')
    video_class = create(:video_class, category: 'Yoga')

    customer_plan = Plan.new(
      id: 1,
      name: 'Básico',
      price: '50',
      categories: [
        Category.new(id: 1, name: 'Yoga'),
        Category.new(id: 2, name: 'FitDance')
      ],
      num_classes_available: 5
    )

    allow(Plan).to receive(:find_customer_plans).with('46465dssafd')
                                                .and_return([customer_plan])

    login_as customer, scope: :customer

    visit video_class_path(video_class)

    expect(page).to have_link 'Participar da aula'
  end

  scenario 'link disappear if customer plan does not category' do
    customer = create(:customer, token: '46465dssafd')
    video_class = create(:video_class, category: 'Crossfit')
    customer_plan = Plan.new(
      id: 1,
      name: 'Básico',
      price: '50',
      categories: [
        Category.new(id: 1, name: 'Yoga'),
        Category.new(id: 2, name: 'FitDance')
      ],
      num_classes_available: 5
    )

    allow(Plan).to receive(:find_customer_plans).with('46465dssafd')
                                                .and_return([customer_plan])

    login_as customer, scope: :customer

    visit video_class_path(video_class)

    expect(page).not_to have_link 'Participar da aula'
  end

  scenario 'link disappear if customer does not have plan' do
    customer = create(:customer, token: '46465dssafd')
    video_class = create(:video_class, category: 'Crossfit')

    allow(Plan).to receive(:find_customer_plans).with('46465dssafd').and_return([])

    login_as customer, scope: :customer

    visit video_class_path(video_class)

    expect(page).not_to have_link 'Participar da aula'
  end
end

feature 'Customer watches video class' do
  scenario 'successfully' do
    customer = create(:customer, token: '46465dssafd')
    video_class = create(:video_class, category: 'Yoga')
    customer_plan = Plan.new(
      id: 1,
      name: 'Básico',
      price: '50',
      categories: [
        Category.new(id: 1, name: 'Yoga'),
        Category.new(id: 2, name: 'FitDance')
      ],
      num_classes_available: 5
    )

    allow(Plan).to receive(:find_customer_plans).with('46465dssafd')
                                                .and_return([customer_plan])

    login_as customer, scope: :customer

    visit video_class_path(video_class)
    click_on 'Participar da aula'

    expect(current_path).to eq video_class_path(video_class)
    expect(customer.watched_classes.length).to eq 1
  end

  scenario 'user can watch class more than once' do
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
      num_classes_available: 5
    )

    allow(Plan).to receive(:find_customer_plans).with('46465dssafd')
                                                .and_return([customer_plan])

    login_as customer, scope: :customer

    visit video_class_path(video_class)
    click_on 'Participar da aula'

    expect(customer.watched_classes.length).to eq 2
  end
end
