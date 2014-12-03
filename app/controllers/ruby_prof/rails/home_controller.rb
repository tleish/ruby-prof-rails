module RubyProf
  module Rails
    class HomeController < RubyProf::Rails::ApplicationController

      PRINTERS = %w(FlatPrinter FlatPrinterWithLineNumbers GraphPrinter GraphHtmlPrinter DotPrinter CallTreePrinter CallStackPrinter MultiPrinter)

      http_basic_authenticate_with name: RubyProf::Rails::Config.username, password: RubyProf::Rails::Config.password if RubyProf::Rails::Config.has_authentication?
      before_filter :cache_class_enabled?, :disabled_alert

      def index
        @config = session[:ruby_prof_rails] || {}
        @profiles = Dir[File.join(RubyProf::Rails::Config.path, "#{request.session_options[:id]}*")]
      end

      def update
        if enabled_config?
          update_session
          flash_updates
        end
        redirect_to action: 'index'
      end

      private

      def flash_updates
        return flash[:warning] = 'Ruby Prof running for current Browser Session...' if enabled?
        flash[:ruby_prof_rails] = :stop
        flash[:notice] = 'Ruby Prof Stopped'
      end

      def enabled?
        session[:ruby_prof_rails][:enabled]
      end

      def update_session
        session[:ruby_prof_rails] = {
          enabled: params[:start].to_i == 1,
          printer: params[:printer],
          measurement: params[:measurement],
          eliminate_methods: string_to_array(params[:eliminate_methods]),
          exclude_threads: string_to_array(params[:exclude_threads])
        }
      end

      def string_to_array(string)
        string.split("\n")
          .reject(&:empty?)
          # .map{ |regex| Regex.new regex }
      end

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
        !Rails.application.config.cache_classes
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