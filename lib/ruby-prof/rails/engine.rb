require 'rack/ruby-prof-rails'
require 'bootstrap-sass'

module RubyProf
  module Rails
    class Engine < ::Rails::Engine
      # isolate_namespace RubyProfRails

      initializer :ruby_prof_rails_middleware do |app|
        app.config.middleware.use 'Rack::RubyProfRails'
      end

    end
  end
end
