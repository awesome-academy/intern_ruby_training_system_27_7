source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.7.1"

gem "active_storage_validations", "0.8.2"
gem "bcrypt", "3.1.13"
gem "bootsnap", ">= 1.4.4", require: false
gem "bootstrap-kaminari-views"
gem "bootstrap-sass", "3.4.1"
gem "cancancan"
gem "config"
gem "devise"
gem "faker", "2.1.2"
gem "figaro"
gem "i18n-js"
gem "image_processing", "1.9.3"
gem "jbuilder", "~> 2.7"
gem "jquery-rails"
gem "kaminari"
gem "mini_magick", "4.9.5"
gem "mysql2", "~> 0.5.3"
gem "puma", "~> 5.0"
gem "rails", "~> 6.1.4"
gem "rails-i18n"
gem "ransack"
gem "sass-rails", ">= 6"
gem "select2-rails"
gem "toastr-rails"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 5.0"

group :development do
  gem "bullet"
  gem "listen", "~> 3.3"
  gem "pry", "~> 0.14.0"
  gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
  gem "web-console", ">= 4.1.0"
end

group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  gem "webdrivers"
end

group :development, :test do
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false
end

group :production do
  gem "pg", "1.1.4"
end

group :development, :test do
  gem "factory_bot_rails"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 4.0.1"
  gem "simplecov"
  gem "simplecov-rcov"
end

gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby)
