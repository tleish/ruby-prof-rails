module RubyProf
  module Rails
    # server configuration for RubyProfRails application
    class Config

      DEFAULT_EXCLUDE_FORMATS = %w{css js json map jpg jpeg png gif}.join(', ')

      class << self
        attr_accessor :username, :password, :path, :exclude_formats, :session_auth_lambda, :debug

        def path
          @path ||= File.join(::Rails.root, 'tmp', 'ruby-prof-rails')
          Pathname(@path)
        end

        def exclude_formats
          @exclude_formats || DEFAULT_EXCLUDE_FORMATS
        end

        def extract_options_from(env)
          Hash(env['rack.session'][:ruby_prof_rails])
        end

        def http_basic_authenticate
          {
            name: username,
            password: password
          }
        end

      end

    end
  end
end
