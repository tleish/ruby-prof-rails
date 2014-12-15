module RubyProf
  module Rails
    # configuration validation for RubyProfRails application
    class ConfigValidation

      CACHE_CLASS_ENABLED_ALERT = %q{<p>To profile a Rails application it is vital to run it using production like settings
          (cache classes, cache view lookups, etc.). Otherwise, Rail's dependency loading code will overwhelm any time spent
          in the application itself (our tests show that Rails dependency loading causes a roughly 6x slowdown).</p>
          <p>To enable Rails Ruby Prof configuration you must initially set config.cache_classes = true.</p>}

      HAS_AUTHENTICATION_ALERT = %q{<p>For security this page is disabled until RubyProf::Rails::Config.username
          and RubyProf::Rails::Config.password has been configured (see documentation). }

      def initialize(args)
        @config = args.fetch(:config)
        @cache_classes = args.fetch(:app_config).cache_classes
      end

      def properly_configured?
        @config.debug || (@cache_classes && has_authentication?)
      end

      def session_auth_lambda?(session)
        session_auth_lambda = @config.session_auth_lambda
        session_auth_lambda ? session_auth_lambda.call(session) : true
      end

      def alerts
        alerts = []
        alerts << CACHE_CLASS_ENABLED_ALERT unless @cache_classes
        alerts << HAS_AUTHENTICATION_ALERT unless has_authentication?
        alerts
      end

      private

      def has_authentication?
        @config.username.present? || @config.password.present?
      end
    end
  end
end
