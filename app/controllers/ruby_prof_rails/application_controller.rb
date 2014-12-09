module RubyProfRails
  class ApplicationController < ActionController::Base
    before_filter :properly_configured?, :session_authenticate, :routes
    http_basic_authenticate_with RubyProf::Rails::Config.http_basic_authenticate if @enable_config

    private

    def session_authenticate
      redirect_to root_path unless RubyProf::Rails::Config.session_authenticate?(session)
    end

    def properly_configured?
      return if @enable_config ||= RubyProf::Rails::Config.properly_configured?
      flash[:alert] = ('<h4>Disabled: </h4><ul><li>' + RubyProf::Rails::Config.alerts.join('</li><li>') + '</li>').html_safe
    end

    def routes
      @routes = ruby_prof_rails_engine
    end
  end
end
