module RubyProfRails
  class HomeController < RubyProfRails::ApplicationController
    before_filter :init_ruby_prof_rails_session

    def index
      @config = session[:ruby_prof_rails]
      @config[:printers] = Array(RubyProf::Rails::Printer.list.first) if @config[:printers].blank?
      @session_id = request.session_options[:id]
      @profiles = RubyProf::Rails::Profiles.list
    end

    def update
      if @enable_config
        update_session
        flash_updates
      end
      redirect_to @routes.ruby_prof_rails_path
    end

    private

    def init_ruby_prof_rails_session
      session[:ruby_prof_rails] ||= {}
    end

    def flash_updates
      return flash[:warning] = 'Ruby Prof running for current Browser Session...' if profiling_active?
      flash[:ruby_prof_rails] = :stop
      flash[:notice] = 'Ruby Prof Stopped' unless flash[:alert].present?
    end

    def profiling_active?
      session[:ruby_prof_rails][:enabled]
    end

    def update_session
      session[:ruby_prof_rails].merge!(
        enabled: enabled?,
        measurement: params[:measurement],
        eliminate_methods: string_to_array(params[:eliminate_methods]),
        exclude_threads: string_to_array(params[:exclude_threads])
      )
      session[:ruby_prof_rails][:printers] = params[:printers] if params[:printers].present?
    end

    def enabled?
      start = (params[:start].to_i == 1)
      valid_printers = RubyProf::Rails::Printer.valid?(params[:printers])
      flash[:alert] = 'Please select a Printer before clicking "Start Profiling".' if start && !valid_printers
      start && valid_printers
    end

    def string_to_array(string)
      string.split("\n")
        .reject(&:empty?)
    end

  end
end