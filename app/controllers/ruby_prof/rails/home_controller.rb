module RubyProf
  module Rails
    class HomeController < RubyProf::Rails::ApplicationController

      before_filter :init_ruby_prof_rails_session

      def index
        @config = session[:ruby_prof_rails] || {}
        @session_id = request.session_options[:id]
        @profiles = RubyProf::Rails::Profiles.list
      end

      def update
        if @enable_config
          update_session
          flash_updates
        end
        redirect_to action: 'index'
      end

      def show
        profile = RubyProf::Rails::Profiles.find(params[:id])
        if profile
          time = profile.time.strftime('%Y-%m-%d_%I-%M-%S-%Z')
          send_file profile.filename, filename: "#{profile.hash[:prefix]}_#{time}.#{profile.hash[:format]}"
        else
          render text: 'Profiler file was not found and may have been deleted.' # write some content to the body
        end
      end

      def destroy
        profile = RubyProf::Rails::Profiles.find(params[:id])
        if profile
          File.unlink profile.filename
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
        return flash[:warning] = 'Ruby Prof running for current Browser Session...' if profiling_active?
        flash[:ruby_prof_rails] = :stop
        flash[:notice] = 'Ruby Prof Stopped'
      end

      def profiling_active?
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
      end

    end
  end
end