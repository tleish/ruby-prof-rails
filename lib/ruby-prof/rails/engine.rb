require 'rack/ruby-prof-rails'

module RubyProf
  module Rails
    class Engine < ::Rails::Engine
      # isolate_namespace RubyProfRails

      engine_name 'ruby_prof_rails_engine'

      initializer :ruby_prof_rails_middleware do |app|
        app.config.middleware.use 'Rack::RubyProfRails'
      end

      config.generators do |g|
        g.template_engine :haml
      end

    end
  end
end
