require_relative 'config'
require_relative 'profiles'

module RubyProf
  module Rails
    # RubyProf Rails Printer Wrapper
    class Printer

      PRINTERS = {
        FlatPrinter: 'flat.txt',
        FlatPrinterWithLineNumbers: 'flat.txt',
        GraphPrinter: 'flat.txt',
        GraphHtmlPrinter: 'graph.html',
        DotPrinter: '.dot',
        CallTreePrinter: 'grind.dat',
        CallStackPrinter: 'stack.html'
      }

      def initialize(options = {})
        env = options.fetch(:env)
        @options = RubyProf::Rails::Config.extract_options_from env
        @request = Rack::Request.new(env)
        @path = RubyProf::Rails::Config.path
      end

      def print(results)
        printer = get_printer.new(results)
        Dir.mkdir(@path) unless ::File.exists?(@path)
        ::File.open(@path + filename, 'w+') do |f|
          printer.print(f)
        end
      end

      private

      def get_printer
        printer = PRINTERS.keys.grep(/^#{@options[:printer]}$/).first || PRINTERS.keys.first
        "RubyProf::#{printer}".constantize
      end

      def filename
        RubyProf::Rails::Profiles.hash_to_filename(
          prefix: RubyProf::Rails::Profiles::PREFIX,
          time: Time.now.to_i,
          session_id: @request.session_options[:id],
          url: url_slice,
          format: format
        )
      end

      def url_slice
        @request.fullpath.slice(0, 50)
      end

      def format
        PRINTERS[@options[:printer].to_sym] || PRINTERS.values.first
      end
    end
  end
end
