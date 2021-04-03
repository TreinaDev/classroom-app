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
    categories = [
      Category.new(id: 1, name: 'Yoga'),
      Category.new(id: 2, name: 'FitDance')
    ]
    video_class = create(:video_class, start_at: '2021-04-16 18:08:04',
                                       end_at: '2021-04-16 18:58:04', category_id: 1)

    allow(Category).to receive(:all).and_return(categories)
    allow(Category).to receive(:find_by).with(id: 1).and_return(categories[0])
    allow(Category).to receive(:find_by).with(id: 2).and_return(categories[1])
    allow(Enrollment).to receive(:find_customer_plan).with('46465dssafd')
                                                     .and_return(nil)

    login_as customer, scope: :customer

    visit video_class_path(video_class)

    expect(page).to have_content video_class.name
    expect(page).to have_content video_class.description
    expect(page).to have_content video_class.user.name
    expect(page).to have_content video_class.category.name
    expect(page).to have_content '18:08 - 18:58'
    expect(page).to have_content '16/04/2021'
  end

  scenario 'must have plan and category allowed' do
    customer = create(:customer, token: '46465dssafd')
    categories = [
      Category.new(id: 1, name: 'Yoga'),
      Category.new(id: 2, name: 'FitDance')
    ]
    video_class = create(:video_class, category_id: 1)

    customer_plan = Plan.new(id: 1, name: 'Plano Black',
                             monthly_rate: 109.90,
                             monthly_class_limit: 30,
                             description: 'Para aqueles que querem entrar em forma',
                             status: 'active',
                             class_categories: categories)

    allow(Category).to receive(:all).and_return(categories)
    allow(Category).to receive(:find_by).with(id: 1).and_return(categories[0])
    allow(Category).to receive(:find_by).with(id: 2).and_return(categories[1])
    allow(Enrollment).to receive(:find_customer_plan).with('46465dssafd')
                                                     .and_return(customer_plan)

    login_as customer, scope: :customer

    visit video_class_path(video_class)

    expect(page).to have_link 'Participar da aula'
  end

  scenario 'link disappears if the plan does not have the category' do
    customer = create(:customer, token: '46465dssafd')
    categories = [
      Category.new(id: 1, name: 'Yoga'),
      Category.new(id: 2, name: 'FitDance'),
      Category.new(id: 3, name: 'Zumba')
    ]
    video_class = create(:video_class, category_id: 3)
    customer_plan = Plan.new(id: 1, name: 'Plano Black',
                             monthly_rate: 109.90,
                             monthly_class_limit: 30,
                             description: 'Para aqueles que querem entrar em forma',
                             status: 'active',
                             class_categories: categories.take(2))

    allow(Category).to receive(:all).and_return(categories)
    allow(Category).to receive(:find_by).with(id: 1).and_return(categories[0])
    allow(Category).to receive(:find_by).with(id: 2).and_return(categories[1])
    allow(Category).to receive(:find_by).with(id: 3).and_return(categories[2])
    allow(Enrollment).to receive(:find_customer_plan).with('46465dssafd')
                                                     .and_return(customer_plan)

    login_as customer, scope: :customer

    visit video_class_path(video_class)

    expect(page).not_to have_link 'Participar da aula'
  end

  scenario 'link disappear if customer does not have plan' do
    customer = create(:customer, token: '46465dssafd')
    categories = [
      Category.new(id: 2, name: 'Crossfit'),
      Category.new(id: 1, name: 'Bodybuilding')
    ]
    video_class = create(:video_class, category_id: 1)
    allow(Category).to receive(:all).and_return(categories)
    allow(Category).to receive(:find_by).with(id: 1).and_return(categories[0])
    allow(Category).to receive(:find_by).with(id: 2).and_return(categories[1])
    allow(Enrollment).to receive(:find_customer_plan).with('46465dssafd')
                                                     .and_return(nil)

    login_as customer, scope: :customer

    visit video_class_path(video_class)

    expect(page).not_to have_link 'Participar da aula'
  end

  scenario 'link disappear if video class is disabled' do
    customer = create(:customer, token: '46465dssafd')
    categories = [
      Category.new(id: 2, name: 'Crossfit'),
      Category.new(id: 1, name: 'Bodybuilding')
    ]
    video_class = create(:video_class, category_id: 1, status: :disabled)
    allow(Category).to receive(:all).and_return(categories)
    allow(Category).to receive(:find_by).with(id: 1).and_return(categories[0])
    allow(Category).to receive(:find_by).with(id: 2).and_return(categories[1])
    allow(Enrollment).to receive(:find_customer_plan).with('46465dssafd')
                                                     .and_return(nil)

    login_as customer, scope: :customer

    visit video_class_path(video_class)

    expect(page).not_to have_link 'Participar da aula'
  end
end

feature 'Customer watches video class' do
  scenario 'successfully' do
    customer = create(:customer, token: '46465dssafd')
    categories = [
      Category.new(id: 1, name: 'Yoga'),
      Category.new(id: 2, name: 'FitDance')
    ]
    video_class = create(:video_class, category_id: 1)
    customer_plan = Plan.new(id: 1, name: 'Plano Black',
                             monthly_rate: 109.90,
                             monthly_class_limit: 30,
                             description: 'Para aqueles que querem entrar em forma',
                             status: 'active',
                             class_categories: categories)

    allow(Enrollment).to receive(:find_customer_plan).with('46465dssafd')
                                                     .and_return(customer_plan)

    allow(Category).to receive(:all).and_return(categories)
    allow(Category).to receive(:find_by).with(id: 1).and_return(categories[0])
    allow(Category).to receive(:find_by).with(id: 2).and_return(categories[1])

    login_as customer, scope: :customer

    visit video_class_path(video_class)
    click_on 'Participar da aula'

    expect(current_path).to eq video_class_path(video_class)
    expect(customer.watched_classes.length).to eq 1
  end

  scenario 'user can watch class more than once' do
    customer = create(:customer, token: '46465dssafd')
    categories = [
      Category.new(id: 1, name: 'Yoga'),
      Category.new(id: 2, name: 'FitDance')
    ]
    video_class = create(:video_class, category_id: 1)
    WatchedClass.create(customer: customer, video_class: video_class)
    customer_plan = Plan.new(id: 1, name: 'Plano Black',
                             monthly_rate: 109.90,
                             monthly_class_limit: 30,
                             description: 'Para aqueles que querem entrar em forma',
                             status: 'active',
                             class_categories: categories)

    allow(Category).to receive(:all).and_return(categories)
    allow(Category).to receive(:find_by).with(id: 1).and_return(categories[0])
    allow(Category).to receive(:find_by).with(id: 2).and_return(categories[1])
    allow(Enrollment).to receive(:find_customer_plan).with('46465dssafd')
                                                     .and_return(customer_plan)

    login_as customer, scope: :customer

    visit video_class_path(video_class)
    click_on 'Participar da aula'

    expect(customer.watched_classes.length).to eq 2
  end
end
