require_relative 'profiles'
require_relative 'printers'
require_relative 'filename_module'

module RubyProf
  module Rails
    # RubyProf Rails PrinterSetup class
    class PrinterSetup
      attr_accessor :key, :printer_class, :filename

      include RubyProf::Rails::FilenameModule

      def initialize(options = {})
        @type = options.fetch(:type)
        @request = options.fetch(:request)
        setup_printer
      end

      private

      def setup_printer
        @key = find_printer.type
        @printer_class = find_printer.printer_class
        @filename = hash_to_filename
      end

      def find_printer
        @printer_config ||= RubyProf::Rails::Printers.find_by(@type) || printer_default
      end

      def printer_default
        RubyProf::Rails::Printers.default
      end

    end
  end
end
