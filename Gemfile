source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

gem "erb_lint", require: false
ruby "3.0.2"
gem "active_storage_validations", "0.8.2"
gem "bcrypt", "3.1.13"
gem "bootsnap", ">= 1.4.4", require: false
gem "bootstrap-sass", "3.4.1"
gem "config"
gem "figaro"
gem "i15r", "~> 0.5.1"
gem "i18n"
gem "image_processing", "1.12.2"
gem "jbuilder", "~> 2.7"
gem "jquery-rails"
gem "mini_magick"
gem "missing_t", "~> 0.3.1"
gem "mysql2", "~> 0.5.4"
gem "pagy"
gem "puma", "~> 5.0"
gem "rails", "~> 6.1.6"
gem "rails-i18n"
gem "redis"
gem "sassc-rails"
gem "sass-rails", ">= 6"
gem "toastr-rails"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 5.0"

group :development, :test do
  gem "pry-rails", platforms: %i(mri mingw x64_mingw)
end

group :development do
  gem "faker", "2.1.2"
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
  gem "web-console", ">= 4.1.0"
end

group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver", ">= 4.0.0.rc1"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby)

group :development, :test do
  gem "byebug", platforms: %i(mri mingw x64_mingw)
  gem "rspec-rails", "~> 4.0.1"
  gem "rubocop", "~> 1.26", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.14.0", require: false
end
