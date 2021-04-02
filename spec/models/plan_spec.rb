require 'rails_helper'

describe Plan do
  context 'PORO' do
    it 'should initialize a new plan' do
      categories = [
        Category.new(id: 1, name: 'Yoga'),
        Category.new(id: 2, name: 'FitDance'),
        Category.new(id: 3, name: 'Crossfit')
      ]
      plan = Plan.new(id: 1, name: 'Plano Black',
                      monthly_rate: '109,90',
                      monthly_class_limit: 30,
                      description: 'Para aqueles que querem entrar em forma',
                      status: 'active',
                      class_categories: categories)
      expect(plan.name).to eq('Plano Black')
      expect(plan.class_categories).to eq categories
      expect(plan.monthly_class_limit).to eq(30)
      expect(plan.monthly_rate).to eq('109,90')
    end
  end

  context 'Fetch API data to get plans' do
    it 'should get all plans' do
      resp_json = File.read(Rails.root.join('spec/support/apis/get_plans.json'))
      resp_double = double('faraday_response', status: 200, body: resp_json)

      allow(Faraday).to receive(:get)
        .with("#{Rails.configuration.external_apis['enrollments_url']}/plans")
        .and_return(resp_double)

      plans = Plan.all

      expect(plans.length).to eq 2

      expect(plans.first.name).to eq 'Plano Black'
      expect(plans.first.class_categories[0].name).to eq 'Yoga'
      expect(plans.first.class_categories[1].name).to eq 'FitDance'
      expect(plans.first.class_categories[2].name).to eq 'Crossfit'
      expect(plans.first.monthly_class_limit).to eq 30
      expect(plans.first.monthly_rate).to eq 109.90

      expect(plans.last.name).to eq 'Plano Smart'
      expect(plans.last.class_categories[0].name).to eq 'Yoga'
      expect(plans.last.class_categories[1].name).to eq 'FitDance'
      expect(plans.last.monthly_class_limit).to eq 15
      expect(plans.last.monthly_rate).to eq 69.90
    end

    it 'should return empty if not authorized' do
      resp_double = double('faraday_response', status: 401, body: '')

      allow(Faraday).to receive(:get)
        .with("#{Rails.configuration.external_apis['enrollments_url']}/plans")
        .and_return(resp_double)

      plans = Plan.all

      expect(plans.length).to eq 0
    end
  end

  context '#watch_video_class?' do
    it 'successfully' do
      video_class = create(:video_class, category_id: 3)
      plan = Plan.new(id: 1, name: 'Plano Smart', monthly_rate: 69.90, monthly_class_limit: 15,
                      description: 'Plano pra quem é esperto', status: 'active',
                      class_categories: [
                        Category.new(id: 1, name: 'Yoga'),
                        Category.new(id: 2, name: 'FitDance'),
                        Category.new(id: 3, name: 'Crossfit')
                      ])
      allow(Category).to receive(:find_by).and_return(plan.class_categories[2])

      expect(plan.watch_video_class?(video_class.category)).to be_truthy
    end

    it 'failure' do
      video_class = create(:video_class, category_id: 3)
      plan = Plan.new(id: 2, name: 'Plano Smart', monthly_rate: 69.90, monthly_class_limit: 15,
                      description: 'Plano pra quem é esperto', status: 'active',
                      class_categories: [
                        Category.new(id: 1, name: 'Yoga'),
                        Category.new(id: 2, name: 'FitDance')
                      ])
      allow(Category).to receive(:find_by).and_return(nil)

      expect(plan.watch_video_class?(video_class.category)).to be_falsy
    end
  end

  context '#build_plan' do
    it 'successfully' do
      json_plan = File.read(Rails.root.join('spec/support/apis/get_customer_plan.json'))
      plan = Plan.new(id: 2, name: 'Plano Smart', monthly_rate: 69.90, monthly_class_limit: 15,
                      description: 'Para aqueles que querem entrar em forma', status: 'active',
                      class_categories: [
                        Category.new(id: 1, name: 'Yoga'),
                        Category.new(id: 2, name: 'FitDance')
                      ])
      expect(Plan.build_plan(json_plan)).to eq(plan)
    end

    it 'failure' do
      json_plan = ''
      expect(Plan.build_plan(json_plan)).to eq(nil)
    end
  end

  context '#build_plans' do
    it 'successfully' do
      json_plans = File.read(Rails.root.join('spec/support/apis/get_plans.json'))
      plans = [
        Plan.new(id: 1, name: 'Plano Black', monthly_rate: 109.90, monthly_class_limit: 30,
                 description: 'Ideal para iniciantes', status: 'active',
                 class_categories: [
                   Category.new(id: 1, name: 'Yoga'),
                   Category.new(id: 2, name: 'FitDance'),
                   Category.new(id: 3, name: 'Crossfit')
                 ]),
        Plan.new(id: 2, name: 'Plano Smart', monthly_rate: 69.90, monthly_class_limit: 15,
                 description: 'Para aqueles que querem entrar em forma', status: 'active',
                 class_categories: [
                   Category.new(id: 1, name: 'Yoga'),
                   Category.new(id: 2, name: 'FitDance')
                 ])
      ]
      expect(Plan.build_plans(json_plans)).to eq(plans)
    end

    it 'failure' do
      json_plans = ''
      expect(Plan.build_plans(json_plans)).to eq([])
    end
  end

  context '#==' do
    it 'successfully' do
      json_plan = File.read(Rails.root.join('spec/support/apis/get_customer_plan.json'))
      plan1 = Plan.build_plan(json_plan)
      plan2 = Plan.build_plan(json_plan)

      expect(plan1 == plan2).to be_truthy
    end

    it 'failure' do
      json_plan = File.read(Rails.root.join('spec/support/apis/get_customer_plan.json'))
      plan1 = Plan.build_plan(json_plan)
      plan2 = Plan.build_plan(json_plan)
      plan2.name = 'Plano Esperto'

      expect(plan1 == plan2).to be_falsy
    end
  end

  context '#eql?' do
    it 'successfully' do
      json_plan = File.read(Rails.root.join('spec/support/apis/get_customer_plan.json'))
      plan1 = Plan.build_plan(json_plan)
      plan2 = Plan.build_plan(json_plan)
      expect(plan1.eql?(plan2)).to be_truthy
    end

    it 'failure' do
      json_plan = File.read(Rails.root.join('spec/support/apis/get_customer_plan.json'))
      plan1 = Plan.build_plan(json_plan)
      plan2 = Plan.build_plan(json_plan)
      plan2.monthly_class_limit = 20
      expect(plan1.eql?(plan2)).to be_falsy
    end
  end

  context '#hash' do
    it 'successfully' do
      json_plan = File.read(Rails.root.join('spec/support/apis/get_customer_plan.json'))
      plan1 = Plan.build_plan(json_plan)
      plan2 = Plan.build_plan(json_plan)
      expect(plan1.hash == plan2.hash).to be_truthy
    end

    it 'failure' do
      json_plan = File.read(Rails.root.join('spec/support/apis/get_customer_plan.json'))
      plan1 = Plan.build_plan(json_plan)
      plan2 = Plan.build_plan(json_plan)
      plan2.monthly_rate = '199,90'
      expect(plan1.hash == plan2.hash).to be_falsy
    end
  end
end
