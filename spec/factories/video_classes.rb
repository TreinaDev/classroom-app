FactoryBot.define do
  factory :video_class do
    name { 'Definir abdômen' }
    description { 'Aula voltada para o fortalecimento muscular do abdômen' }
    video_url { 'smartflix.com.br/definir_abdomen' }
    start_at { '2021-04-16 18:08:04' }
    end_at { '2021-04-16 18:58:04' }
    category { 'Musculação' }

    user
  end
end
