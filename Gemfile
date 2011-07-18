source 'http://rubygems.org'

gem 'rails', '3.0.1'

gem 'rake', '0.8.7' #fix rake exrror w/ 1.9.2 and rake 0.9.0 - use 'bundle exec rake db:migrate'
#gem 'rake', '0.9.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3-ruby', :require => 'sqlite3'

gem 'will_paginate', '3.0.pre2'

gem 'devise'

#https://github.com/rails/jquery-ujs
gem 'jquery-rails', '>= 1.0.3'

gem 'nokogiri'

#couldn't get backgroundrb running - problems with rake and this rvm grah
#gem 'packet'
#gem 'chronic'

gem 'rufus-scheduler'

group :development do
  gem 'rspec-rails'
#  gem 'rspec-rails', '2.0.1'
  gem 'faker', '0.3.1'
  gem 'annotate-models', '1.0.4' #for mode schema notes
end

group :test do
  gem 'rspec'
#  gem 'rspec', '2.0.1'
  gem 'factory_girl_rails', '1.0'
  gem 'webrat', '0.7.1' #use 0.7.1 to prevent redirect error in rspec
end



# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
