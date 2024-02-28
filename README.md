# Loan App

Loan App allows users to create loan requests and receive PDF reports directly via email.

## Features
* Create loan requests in a multi step form
* Get system generated PDF reports reflecting loan request details accordin to the terms and conditions of the comapny via emal

## Prerequisites
* Ensure you have the following system dependencies installed on your machine:


- Ruby version: `3.1.3`
- Rails version: `6.1.0`
- System dependencies:
  - Ruby
  - Rails
  - Python
  - Node.js (`>= v.18`)
  - Java
  - Redis

## Installation and Setup

### Clone the Repository

```sh
git clone https://github.com/de-ahsan/longleaf-lending.git

cd longleaf-lending
```

### Install Dependencies
```sh
bundle install
```

### Database Setup
* Create the database:
```sh
bundle exec rails db:create
```
* Run database migrations:
```sh
bundle exec rails db:migrate
```

### Start Sidekiq
* Ensure you have Redis and Sidekiq running before starting the app.
```sh
bundle exec sidekiq
```

### Start the Rails Server
```sh
rails server
```

or
```sh
./bin/dev
```

### Running Tests
* To run the test suite, execute:

```sh
bundle exec rspec
```
## In case of asset pipeline or JS errors
* ensure your node version is at least v.18
* install webpack(er) if not already (do not replace the already generated babel config file)
`RAILS_ENV=development bundle exec rails webpacker:install`
* You may need to precompile the assets after upgrading any conflicting dependencies.
```sh
$ rm -rf node_modules yarn.lock
$ yarn install
$ yarn upgrade
$ rails assets:precompile
```
in some cases you may need to also run these
```sh
$ RAILS_ENV=development bundle exec rails webpacker:install

$ bin/webpack-dev-server
```
And lastly run the server again `rails server`.
