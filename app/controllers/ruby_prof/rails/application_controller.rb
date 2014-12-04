module RubyProf
  module Rails
    class ApplicationController < ActionController::Base
      http_basic_authenticate_with name: RubyProf::Rails::Config.username, password: RubyProf::Rails::Config.password if RubyProf::Rails::Config.has_authentication?
      before_filter :cache_class_enabled?, :disabled_alert

      private

      def disabled_alert
        flash[:alert] = nil
        return if enabled_config?
        has_authentication_alert unless has_authentication?
        cache_class_enabled_alert unless cache_class_enabled?
      end

      def enabled_config?
        @enable_config = cache_class_enabled? && has_authentication?
      end

      def cache_class_enabled?
        ::Rails.application.config.cache_classes
      end

      def cache_class_enabled_alert
        flash[:alert] = %q{<p><b>Disabled: </b> To profile a Rails application it is vital to run it using production like settings
                        (cache classes, cache view lookups, etc.). Otherwise, Rail's dependency loading code will overwhelm any time spent
                        in the application itself (our tests show that Rails dependency loading causes a roughly 6x slowdown).</p>
                        <p>To enable Rails Ruby Prof configuration you must initially set config.cache_classes = true.</p>}.html_safe
        false
      end

      def has_authentication?
        RubyProf::Rails::Config.has_authentication?
      end

      def has_authentication_alert
        flash[:alert] = %q{<p><b>Disabled: </b> For security this page is disabled until RubyProf::Rails::Config.username
                        and RubyProf::Rails::Config.password has been configured (see documentation). }.html_safe
      end
    end
  end
end
