FactoryBot.define do
  factory :video_class do
    name { 'MyString' }
    description { 'MyText' }
    video_url { 'MyString' }
    start_at { '2021-03-16 18:08:04' }
    end_at { '2021-03-16 18:08:04' }

    user
  end
end
