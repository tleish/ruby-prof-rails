module RubyProf
  module Rails
    class ApplicationController < ActionController::Base
      before_filter :properly_configured?
      http_basic_authenticate_with RubyProf::Rails::Config.http_basic_authenticate if @enable_config

      private

      def properly_configured?
        return if @enable_config ||= RubyProf::Rails::Config.properly_configured?
        flash[:alert] = ('<h4>Disabled: </h4><ul><li>' + RubyProf::Rails::Config.alerts.join('</li><li>') + '</li>').html_safe
      end

    end
  end
end
