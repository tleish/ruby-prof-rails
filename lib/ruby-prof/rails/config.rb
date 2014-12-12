module RubyProf
  module Rails
    # server configuration for RubyProfRails application
    class Config

      class << self
        attr_accessor :username, :password, :path, :session_auth_lambda, :debug

        def path
          @path ||= ::Rails.root + 'tmp/performance'
          Pathname(@path)
        end

        def extract_options_from(env)
          Hash(env['rack.session'][:ruby_prof_rails])
        end

        def http_basic_authenticate
          {name: username, password: password}
        end

      end

    end
  end
end
