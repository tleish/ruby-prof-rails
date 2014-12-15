require_relative 'config'
require_relative 'profiles'
require_relative 'printer_setup'
require 'ruby-prof-flamegraph'
require 'ostruct'

module RubyProf
  module Rails
    # RubyProf Rails Printer Wrapper
    class Printer

      def initialize(options = {})
        env = options.fetch(:env)
        @options = RubyProf::Rails::Config.extract_options_from env
        @request = Rack::Request.new(env)
        @path = RubyProf::Rails::Config.path
        @printers = RubyProf::Rails::Printers
      end

      def print(results)
        printers = Array(@options[:printers]).uniq
        printers.each do |printer_key|
          print_for(printer_key, results)
        end
      end

      private

      def print_for(type, results)
        setup = RubyProf::Rails::PrinterSetup.new(type: type, request: @request)
        printer = setup.printer_class.new(results)
        Dir.mkdir(@path) unless ::File.exists?(@path)
        ::File.open(@path + setup.filename, 'w+') do |file|
          printer.print(file)
        end
      end

    end
  end
end
