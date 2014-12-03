module RubyProf
  module Rails
    class HomeController < RubyProf::Rails::ApplicationController

      http_basic_authenticate_with name: RubyProf::Rails::Config.username, password: RubyProf::Rails::Config.password if RubyProf::Rails::Config.has_authentication?
      before_filter :init_ruby_prof_rails_session, :cache_class_enabled?, :disabled_alert

      def index
        @config = session[:ruby_prof_rails] || {}
        @session_id = request.session_options[:id]
        @profiles = RubyProf::Rails::Profiles.list
      end

      def update
        if enabled_config?
          update_session
          flash_updates
        end
        redirect_to action: 'index'
      end

      def show
        path = RubyProf::Rails::Profiles.find(params[:id])
        if File.exist?(path)
          file_hash = RubyProf::Rails::Profiles.filename_hash(File.basename(path))
          time = Time.at(file_hash[:time].to_i).strftime('%Y-%m-%d_%I-%M-%S-%Z')
          send_file path, filename: "#{RubyProf::Rails::Profiles::PREFIX}_#{time}.#{file_hash[:format]}"
        else
          render text: 'Profiler file was not found and may have been deleted.' # write some content to the body
        end
      end

      def destroy
        path = RubyProf::Rails::Profiles.find(params[:id])
        if File.exist?(path)
          File.unlink path
          flash[:notice] = 'Profile deleted'
        else
          flash[:alert] = 'Profile not found'
        end
        redirect_to action: 'index'
      end

      private

      def init_ruby_prof_rails_session
        session[:ruby_prof_rails] ||= {}
      end

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

      # def get_profiles
      #   session_id = request.session_options[:id]
      #   Dir[File.join(RubyProf::Rails::Config.path, "#{session_id}*")]
      #     .reverse
      # end

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
        !::Rails.application.config.cache_classes
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