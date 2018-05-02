require 'ruby-prof/rails/config_validation'

module RubyProfRails
  class ApplicationController < ActionController::Base
    before_action :init_vars, :properly_configured?, :session_authenticate
    http_basic_authenticate_with RubyProf::Rails::Config.http_basic_authenticate

    private

    def init_vars
      @config = RubyProf::Rails::Config
      @config_validation = RubyProf::Rails::ConfigValidation.new(config: @config, app_config: ::Rails.application.config)
      @routes = ruby_prof_rails_engine
    end

    def properly_configured?
      return if @enable_config ||= @config_validation.properly_configured?
      flash[:alert] = ('<h4>Disabled: </h4><ul><li>' + @config_validation.alerts.join('</li><li>') + '</li>').html_safe
    end

    def session_authenticate
      redirect_to root_path unless @config_validation.session_auth_lambda?(session)
    end

  end
end
