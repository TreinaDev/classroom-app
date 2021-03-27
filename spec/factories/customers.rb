FactoryBot.define do
  factory :customer do
    full_name { 'Carlos Eduardo Arduino' }
    email { 'cae@email.com' }
    password { '123456' }
    cpf { '320234909-43' }
    age { 56 }
    payment_methods { 'Boleto' }
  end
end
