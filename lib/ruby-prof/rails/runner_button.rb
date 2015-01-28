
module RubyProf
  module Rails
    class RunnerButton

      BUTTON_HTML_PATH = ::File.expand_path('../../../app/views/ruby_prof_rails/runner/_button.html', ::File.dirname(__FILE__))

      def initialize(options)
        @status, @headers, @body = options.fetch(:response)
      end

      def draw
        return [@status, @headers, @body] unless is_valid_html_page?
        @response = Rack::Response.new([], @status, @headers)
        add_button_to_response
        @response.finish
      end

      private

      def add_button_to_response
        if @body.is_a? String
          @response.write inject(@body, button_html)
        else
          @body.each { |fragment| @response.write inject(fragment, button_html) }
          @body.close if @body.respond_to? :close
        end
      end

      def inject(fragment, html)
        fragment.gsub(/<\/body>/, "#{html}</body>")
      end

      def button_html
        @button_html ||= ::File.open(BUTTON_HTML_PATH, 'rb')
                           .read
                           .gsub('href="#"', 'href="' + ruby_prof_rails_route_path + '"')
      end

      def is_valid_html_page?
        @headers['Content-Type'] =~ /text\/html/
      end

      def ruby_prof_rails_route_path
        ::Rails.application.routes.named_routes['ruby_prof_rails_engine']
          .app.routes.named_routes.routes[:ruby_prof_rails_home_index].path.spec.to_s
          .gsub('(.:format)', '')
      end

    end
  end
end