source "https://rubygems.org"

gem "rails", "4.1.12"

gem "unicorn"

#gem "mysql2", ">= 0.3.14"

# uncomment to use PostgreSQL
gem "pg"
#
# NOTE: If you use PostgreSQL, you must still leave enabled the above mysql2
# gem for Sphinx full text search to function.

#gem "thinking-sphinx", "~> 3.1.2"

gem 'pg_search'
#gem 'searchkick'

gem "uglifier", ">= 1.3.0"
gem "jquery-rails"
gem "dynamic_form"

gem "exception_notification"

#gem "bcrypt", "~> 3.1.2"
gem 'devise'

gem "nokogiri", "= 1.6.1"
gem "htmlentities"
gem "rdiscount"

# for twitter-posting bot
gem "oauth"


gem "omniauth-facebook"
gem "omniauth-google-oauth2"

# for parsing incoming mail
gem "mail"

gem 'mailgun_rails', '0.8.0', :path=> "vendor/gems/mailgun_rails-0.8.0"#, :require => ["mailgun_rails", "rest-client"]

gem "recaptcha", require: "recaptcha/rails"

gem 'social-share-button'

gem 'phonelib'

#gem 'activejob_backport'

gem 'sidekiq'
#gem 'devise-async'

group :test, :development do
  gem "rspec-rails", "~> 2.6"
  gem "machinist"
  gem "sqlite3"
  gem "faker"
  gem 'web-console', '~> 2.0'
  gem 'puma'
end
