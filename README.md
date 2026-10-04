# Shelfwise

The web shop of a small independent bookshop: browse the catalogue, add books
to a cart, check out with a name and shipping address, and see the order. The
shop owner sees every order and marks it shipped. There is no login and no
payment step: placing an order records it.

Built with Ruby on Rails, Active Record on SQLite, and ERB views with one plain
CSS file.

## Getting started

```bash
bundle install
bin/rails db:prepare   # creates storage/development.sqlite3, migrates, loads sample data
bin/rails server
```

Open [http://localhost:3000](http://localhost:3000).

`bin/rails db:seed` can be run at any time: it replaces everything in the
database with the sample shop.

## How it works

- **Books** have a title, author, ISBN, genre (Fiction, Mystery, Science or
  History), year, description, price and how many are in stock. Money is
  stored as whole cents.
- A **cart** is created on the first add to cart; the browser keeps its token
  in the `cart_token` cookie. A cart has one line per book, and a line's
  quantity can never go above the book's stock. The cart total uses each
  book's current price.
- **Placing an order** turns the cart into an order in one step: it copies
  each book's title and price onto the order, takes the quantities out of
  stock and empties the cart. If any line is now over the stock, nothing
  changes.
- An order is `placed` or `shipped`; only a placed order can be marked shipped.
- When a rule refuses something (not enough stock, an empty cart), the model
  raises `ShopError` and its message is shown on the page you were on.

| Path                                     | What it is                                 |
| ---------------------------------------- | ------------------------------------------ |
| `db/migrate/`, `db/schema.rb`            | the tables                                 |
| `db/seeds.rb`                            | the sample shop                            |
| `app/models/`                            | the cart and order rules                   |
| `app/controllers/`, `app/views/`         | pages and form actions                     |
| `app/assets/stylesheets/application.css` | the styles                                 |
| `test/models/`                           | the tests                                  |

## Changing the database

```bash
bin/rails generate migration AddSomethingToBooks
bin/rails db:migrate   # applies it and updates db/schema.rb
```

## Tests

```bash
bin/rails test
```
