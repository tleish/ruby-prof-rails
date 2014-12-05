module RubyProf
  module Rails
    # server configuration for RubyProfRails application
    class Config

      CACHE_CLASS_ENABLED_ALERT = %q{<p>To profile a Rails application it is vital to run it using production like settings
          (cache classes, cache view lookups, etc.). Otherwise, Rail's dependency loading code will overwhelm any time spent
          in the application itself (our tests show that Rails dependency loading causes a roughly 6x slowdown).</p>
          <p>To enable Rails Ruby Prof configuration you must initially set config.cache_classes = true.</p>}

      HAS_AUTHENTICATION_ALERT = %q{<p>For security this page is disabled until RubyProf::Rails::Config.username
          and RubyProf::Rails::Config.password has been configured (see documentation). }

      class << self
        attr_accessor :username, :password, :path

        def path
          @path = ::Rails.root + 'tmp/performance' if @path.blank?
          Pathname(@path)
        end

        def extract_options_from(env)
          Hash(env['rack.session'][:ruby_prof_rails])
        end

        def properly_configured?
          cache_class_enabled? && has_authentication?
        end

        def cache_class_enabled?
          ::Rails.application.config.cache_classes
        end

        def has_authentication?
          username.present? || password.present?
        end

        def alerts
          alerts = []
          alerts << CACHE_CLASS_ENABLED_ALERT unless has_authentication?
          alerts << HAS_AUTHENTICATION_ALERT unless cache_class_enabled?
          alerts
        end

        def http_basic_authenticate
          {name: username, password: password}
        end

      end

    end
  end
end
