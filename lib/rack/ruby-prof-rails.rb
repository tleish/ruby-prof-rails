require 'ruby-prof'
require 'ruby-prof/rails/runner'

module Rack
    class RubyProfRails

      def initialize(app, options = {})
        @app = app
        @env = Object.new
      end

      def call(env)
        @ruby_prof_rails = ::RubyProf::Rails::Runner.new( env: env, app: @app )
        if @ruby_prof_rails.skip?
          @app.call(env)
        else
          @ruby_prof_rails.call(env)
        end
      end

    end
end
