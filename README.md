# README

This Rails app is an implementation of a bit.ly like url shortener.

Shortened urls are generated using a base62 token strategy, trying to avoid collisions and also reducing the database size. Tokens have 8 characters, which gives us 62^8 possible tokens.

## Technologies

* Ruby 2.7.1
* Rails 6.1.4
* Postgres 12.7

## Development with Docker

Building api image:
```sh
  docker-compose build
```

Setting the database up:
```sh
  docker-compose run api rake db:create
  docker-compose run api bin/setup
```

Running the app:
```sh
  docker-compose up
```

Running the specs:
```sh
  docker-compose run api rspec
```

