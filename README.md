###Lobsters Rails Project

This is a fork of Lobsters Rails Project with certain new features and some backend changes:
* Uses elasticsearch for search engine
* Mailgun for mailing
* Postgresql for database
* Google, Facebook OAuth login
* Devise for authentication system

While you are free to fork this code and modify it (according to the [license](https://github.com/jcs/lobsters/blob/master/LICENSE))
to run your own link aggregation website, this source code repository and bug
tracker are only for the site operating at [lobste.rs](https://lobste.rs/).
Please do not use the bug tracker for support related to operating your own
site unless you are contributing code that will also benefit [lobste.rs](https://lobste.rs/).

####Contributing bugfixes and new features

Please see the [CONTRIBUTING](https://github.com/jcs/lobsters/blob/master/CONTRIBUTING.md)
file.

####Initial setup

* Install Ruby.  This code has been tested with Ruby versions 1.9.3, 2.0.0, 2.1.0,
and 2.3.0.

* Checkout the lobsters git tree from Github

         $ git clone git://github.com/jcs/lobsters.git
         $ cd lobsters
         lobsters$ 

* Run Bundler to install/bundle gems needed by the project:

         lobsters$ bundle

* Create a postgresql database, username, and password and put them in a
`config/database.yml` file:

          development:
            adapter: postgresql
            encoding: unicode
            database: lobsters_test
            host: localhost
            pool: 5
            timeout: 5000
            username: *username*
            password: *password*


* Create a secrets file at `config/secrets.rb`:
          
          development:
            secret_key_base: *output of rake secret*

            elasticsearch_url: *elasticsearch server url (default is localhost:9200)*

            mailgun_domain: *mailgun domain*

            mailgun_api_key: *mailgun api key*
  
            omniauth_facebook_app_id: *facebook app client id*
            omniauth_facebook_app_secret: *facebook app client secret*

            omniauth_google_client_id: *google app client id*
            omniauth_google_client_secret: *google app client secret*


* Load the schema into the new database:

          lobsters$ rake db:schema:load


* (Optional, only needed for the search engine) Install elasticsearch.  Build config and start server:

          lobsters$ rake searchkick:reindex:all

* Define your site's name and default domain, which are used in various places,
in a `config/initializers/production.rb` or similar file:

          class << Rails.application
            def domain
              "example.com"
            end
          
            def name
              "Example News"
            end
          end
          
          Rails.application.routes.default_url_options[:host] = Rails.application.domain

* Put your site's custom CSS in `app/assets/stylesheets/local`.

* Seed the database to create an initial administrator user and at least one tag:

          lobsters$ rake db:seed
          created user: test, password: test
          created tag: test

* Run the Rails server in development mode.  You should be able to login to
`http://localhost:3000` with your new `test` user:

          lobsters$ rails server

* In production, set up crontab or another scheduler to run regular jobs:

          */20 * * * * cd /path/to/lobsters && env RAILS_ENV=production bundle exec rake searchkick:reindex:all > /dev/null
          */5 * * * *  cd /path/to/lobsters && env RAILS_ENV=production sh -c 'bundle exec ruby script/mail_new_activity; bundle exec ruby script/post_to_twitter'
