# Sistemas de Aulas

## Breve Descrição

Responsável pelo gerenciamento das aulas na plataforma **SmartFlix** com atribuições dedicadas ao cadastro dos Alunos, Professores e Aulas. É a primeira camada de contato entre visitante ou cliente (aluno) com o objetivo principal de oferecer serviço de streaming de aulas com limitações de acesso em função do plano adquirido.

## Principais Features

[ ] Visitante visualiza lista com todas aulas cadastradas

[ ] Cadastro de Aluno

[ ] Cadastro de Professor

[ ] Professor cadastra aula vinculada há uma categoria

[ ] Aluno assiste aulas com limites estabelecidos de acordo com regra de negócio do plano contrado


## Requisitos

- [Ruby 2.7.2]
- [Rails 6.1.3]
- [NodeJS]
- [Yarn]

### Gems utilizadas

- [Sqlite3 (1.4) ]
- [devise (4.7.3) ]
- [FactoryBot Rails (6.1.0) ]
- [Faraday (1.3.0) ]
- [Rspec (3.10.1) ]
- [Capybara (3.35.3) ]
- [Shoulda-matchers (4.5.1) ]
- [Rubocop-rails (2.9.1) ]
- [Simplecov (0.21.2) ]

## Integrações com outros sistemas

### Consumo de API exposta pelo sistema PAGAMENTOS/FRAUDES

Obtenção da lista dos meios de pagamentos disponíveis aos alunos:

endpoint: `` GET http://localhost:5000/api/v1/payment_methods `` 

Exemplo de retorno com status 200: sucesso

*Amostra retirada do arquivo README.md projeto PAYMENT-FRAUD*

```JSON
[
  { 
    "id": 1, 
    "name": "Cartão de crédito", 
    "created_at": "2021-03-25 20:47:39.461725000 -0300", 
    "updated_at": "2021-03-25 20:47:39.461725000 -0300", 
    "max_installments": 4, 
    "code": "CRT CREDIT", 
    "status": "active" 
  },
  { 
    "id": 2, 
    "name": "Boleto", 
    "created_at": "2021-03-25 20:47:39.461725000 -0300", 
    "updated_at": "2021-03-25 20:47:39.461725000 -0300", 
    "max_installments": 1, 
    "code": "BOLET", 
    "status": "active" 
  }
]
```
Com os atributos **id** e **name** sendo utilizados na lógica do projeto Sistema de Aulas.

### Consumo de API exposta pelo sistema MATRICULAS/PLANOS

:warning: endpoint: ``GET ??????`` para consultar planos do aluno e categorias de aulas liberadas

### Persistência do resgistro de alunos em base externa MATRICULAS/PLANOS

endpoint: `` POST http://localhost:4000/api/v1/customers `` contendo informações no *body*

```JSON
  {
    "id": 1, 
    "full_name": "Arnaldo Jabor", 
    "birth_date": "1981-03-25",
    "cpf": "31913099945",
    "email": "arnaldo@gmail.com",
    "payment_methods": 2
  }
```

Obtendo como resposta o atributo *token* retornado

```JSON
  {
    "token": "M4t"
  }
```

## Rodando o projeto

No terminal clone o projeto

```
git clone git@github.com:TreinaDev/classroom-app.git
```

Abra o diretório pelo terminal

```bash
cd  classroom-app
```

Rode o script bin setup para configurar o projeto

```bash
bin/setup
```

Para inicializar o servidor:

```bash
rails s
```

## Alimentando o banco

Para alimentar o banco com dados de teste:

```bash
rails db:seed
```

## Personas

| Papel | Nome | Descrição | E-mail | Senha | Idade | CPF | Método de Pagamento |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Professor | Pedro Rocha Silveira | Filho de jardineiro e diarista, seu sonho era ser jogador de futebol, mas uma lesão o privou deste sonho. Cursou educação física na intenção de virar treinador de futebol, mas acabou se apaixonando por musculação. | pedrorocha02@smartflix.com.br | pedroca02 | X | X | X
| Professor | Paulo Torres Filho | Quando criança era hiperativo, praticou jiu jitsu, taekwondo, karatê, capoeira e tudo mais que imaginar. Descobriu o parkour quando tinha 21 e com 25 anos estava finalizando seus estudos para o ensino de crossfit. | paulo-filho@smartflix.com.br | f@ul0P1lh0 | X | X | X
| Professora | Maria Rosa D'Santo | Bailarina profissional, já se apresentou em diversos países. Filha de italiana com brasileiro, sonhava em ser uma "globeleza" quando mais nova, mas cresceu numa família religiosa. Hoje, ensina zumba como forma de manter o corpo e a mente ocupados. | mariasanto123@smartflix.com.br | Warro_$ant$ | X | X | X
| Aluno | Júlio César de Oliveira | Pai de família, casado, duas filhas. Herdou a profissão de mecânico do pai. Só não tem uma vida perfeita, porque dirige um Gol 1.0. Pratica musculação desde os 16, inspirado pelos filmes do grande Arnold. | julio101cesar@hotmail.com | c&s@rJulh0 | 40 | 123.456.789-10 | cartão
| Aluna | Joana da Silva Santos | Mais de 5 mil seguidores no instagram, tem cabelo colorido e faz lives de LoL na Twitch enquanto toma Monster sabor maçã verde. Resolveu se exercitar, porque ficar muito tempo parada a fez ter problemas de saúde. | josilsantos2000@gmail.com | J0j0S1lv | 20 | 102.456.789-30 | boleto
| Aluna | Ana Mara de Mesquita | Filha de mãe solteira, gerente em uma agência de viagens, sempre dando o seu melhor para que consiga dar uma boa vida para dona Creuza. Resolveu se exercitar, pois nunca se sabe quando precisará correr de uma horda zumbi. | anamesq@outlook.com | maraana782 | 29 | 089.823.479-19 | transferência

* * *

## Desenvolvedores (ordem alfabética)

- https://github.com/carlos-arduino
- https://github.com/Guilherme4857
- https://github.com/gvicencotti
- https://github.com/JuliaJubileu
- https://github.com/matheusma37
- https://github.com/MilenaF-dev
- https://github.com/rafelluiz

