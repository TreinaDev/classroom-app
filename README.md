## Sistema de Aulas - Breve Descrição

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
- [FactoryBots Rails (6.1.0) ]
- [Faraday (1.3.0) ]
- [Rspec (3.10.1) ]
- [Capibara (3.35.3) ]
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

:warning: Implementar arquivo seeds.rb

## Desenvolvedores (ordem alfabética)

- https://github.com/carlos-arduino
- https://github.com/Guilherme4857
- https://github.com/gvicencotti
- https://github.com/JuliaJubileu
- https://github.com/matheusma37
- https://github.com/MilenaF-dev
- https://github.com/rafelluiz

