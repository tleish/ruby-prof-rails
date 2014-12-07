require 'minitest/spec'
require 'minitest/autorun'
require 'rack/test'
require 'mocha'
require 'mocha/setup'
require './lib/ruby-prof/rails/config'

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../test/dummy/config/environment.rb',  __FILE__)
# ActiveRecord::Migrator.migrations_paths = [File.expand_path('../../test/dummy/db/migrate', __FILE__)]
# ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/rails/capybara'

Rails.backtrace_cleaner.remove_silencers!

RubyProf::Rails::Config.path = 'test/tmp'