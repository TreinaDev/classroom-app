# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

teachers = User.create(
  [
    {
      name: 'Pedro Rocha Silveira',
      password: 'pedroca02',
      email: 'pedrorocha02@smartflix.com.br'
    },
    {
      name: 'Paulo Torres Filho',
      password: 'f@ul0P1lh0',
      email: 'paulo-filho@smartflix.com.br'
    },
    {
      name: "Maria Rosa D'Santo",
      password: 'Warro_$ant$',
      email: 'mariasanto123@smartflix.com.br'
    }
  ]
)

Customer.create(
  [
    {
      full_name: 'Júlio César de Oliveira',
      age: 40,
      cpf: '123.456.789-10',
      payment_methods: 'cartão',
      password: 'c&s@rJulh0',
      email: 'julio101cesar@hotmail.com',
      token: 'ALEBy2tP'
    },
    {
      full_name: 'Joana da Silva Santos',
      age: 20,
      cpf: '102.456.789-30',
      payment_methods: 'boleto',
      password: 'J0j0S1lv',
      email: 'josilsantos2000@gmail.com',
      token: '3iLE5p2P'
    },
    {
      full_name: 'Ana Mara de Mesquita',
      age: 29,
      cpf: '089.823.479-19',
      payment_methods: 'transferência',
      password: 'maraana782',
      email: 'anamesq@outlook.com',
      token: '1S2EpZhF'
    }
  ]
)

date_now = Time.zone.today

VideoClass.create(
  [
    {
      name: 'Aula Inaugural',
      description: 'Primeira aula de zumba',
      video_url: 'www.smartflix.com.br/video_classes/1/play',
      start_at: "#{date_now.strftime}T20:00:00-03:00",
      end_at: "#{date_now.strftime}T21:30:00-03:00",
      category: 1,
      user_id: teachers[2].id
    },
    {
      name: 'Aula 01 - Zumba',
      description: 'Aula de movimentos básicos.',
      video_url: 'www.smartflix.com.br/video_classes/2/play',
      start_at: "#{(date_now + 3).strftime}T20:00:00-03:00",
      end_at: "#{(date_now + 3).strftime}T21:30:00-03:00",
      category: 1,
      user_id: teachers[2].id
    },
    {
      name: 'Aula 02 - Zumba',
      description: 'Indo um pouco além do básico.',
      video_url: 'www.smartflix.com.br/video_classes/3/play',
      start_at: "#{(date_now + 6).strftime}T20:00:00-03:00",
      end_at: "#{(date_now + 6).strftime}T21:30:00-03:00",
      category: 1,
      user_id: teachers[2].id
    },
    {
      name: 'Aula Inaugural',
      description: 'Primeira aula de crossfit',
      video_url: 'www.smartflix.com.br/video_classes/4/play',
      start_at: "#{date_now.strftime}T20:00:00-03:00",
      end_at: "#{date_now.strftime}T21:30:00-03:00",
      category: 2,
      user_id: teachers[1].id
    },
    {
      name: 'Aula 01 - Crossfit',
      description: 'Aula de aquecimento e movimentos básicos.',
      video_url: 'www.smartflix.com.br/video_classes/5/play',
      start_at: "#{(date_now + 3).strftime}T20:00:00-03:00",
      end_at: "#{(date_now + 3).strftime}T21:30:00-03:00",
      category: 2,
      user_id: teachers[1].id
    },
    {
      name: 'Aula 02 - Crossfit',
      description: 'Indo um pouco além do básico.',
      video_url: 'www.smartflix.com.br/video_classes/6/play',
      start_at: "#{(date_now + 6).strftime}T20:00:00-03:00",
      end_at: "#{(date_now + 6).strftime}T21:30:00-03:00",
      category: 2,
      user_id: teachers[1].id
    },
    {
      name: 'Aula Inaugural',
      description: 'Primeira aula de musculação.',
      video_url: 'www.smartflix.com.br/video_classes/7/play',
      start_at: "#{date_now.strftime}T20:00:00-03:00",
      end_at: "#{date_now.strftime}T21:30:00-03:00",
      category: 3,
      user_id: teachers[0].id
    },
    {
      name: 'Aula 01 - Bodybuilding',
      description: 'Aula de aquecimento e movimentos básicos.',
      video_url: 'www.smartflix.com.br/video_classes/8/play',
      start_at: "#{(date_now + 3).strftime}T20:00:00-03:00",
      end_at: "#{(date_now + 3).strftime}T21:30:00-03:00",
      category: 3,
      user_id: teachers[0].id
    },
    {
      name: 'Aula 02 - Bodybuilding',
      description: 'Indo um pouco além do básico.',
      video_url: 'www.smartflix.com.br/video_classes/9/play',
      start_at: "#{(date_now + 6).strftime}T20:00:00-03:00",
      end_at: "#{(date_now + 6).strftime}T21:30:00-03:00",
      category: 3,
      user_id: teachers[0].id
    }
  ]
)
