require_relative 'config'
require_relative 'profiles'
require 'ostruct'

module RubyProf
  module Rails
    # RubyProf Rails Printer Wrapper
    class Printer

      PRINTERS = {
        FlatPrinter: 'flat.txt',
        FlatPrinterWithLineNumbers: 'flat.num.txt',
        GraphPrinter: 'graph.txt',
        GraphHtmlPrinter: 'graph.html',
        DotPrinter: 'graph.dot',
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
        printers = Array(@options[:printers]).uniq
        printers.each do |printer_key|
          print_for(printer_key, results)
        end
      end

      class << self
        def valid?(printers)
          printers = Array(printers)
          return false if printers.blank?
          valid_printers = list & printers
          valid_printers.present? && valid_printers == printers
        end

        def list
          PRINTERS.keys.map(&:to_s)
        end
      end

      private

      def print_for(key, results)
        setup = setup_printer(key)
        printer = setup.printer.new(results)
        Dir.mkdir(@path) unless ::File.exists?(@path)
        ::File.open(@path + setup.filename, 'w+') do |f|
          printer.print(f)
        end
      end

      def setup_printer(key)
        printer_key = PRINTERS.keys.grep(/^#{key}$/).first || PRINTERS.keys.first
        OpenStruct.new(
          key: printer_key,
          printer: "RubyProf::#{printer_key}".constantize,
          filename: filename(PRINTERS[printer_key])
        )
      end

      def filename(format)
        RubyProf::Rails::Profiles.hash_to_filename(
          prefix: RubyProf::Rails::Profiles::PREFIX,
          time: Time.now.to_i,
          session_id: @request.session_options[:id],
          url: url_slice,
          format: format
        )
      end

      def url_slice
        slice = @request.fullpath.slice(0, 50)
        slice << '...' unless slice == @request.fullpath
        slice
      end

    end
  end
end
