require_relative 'profiles'
require_relative 'printers'

module RubyProf
  module Rails
    # RubyProf Rails PrinterSetup class
    class PrinterSetup
      attr_accessor :key, :printer_class, :filename

      def initialize(options = {})
        @type = options.fetch(:type)
        @request = options.fetch(:request)
        setup_printer
      end

      private

      def setup_printer
        @key = find_printer.type
        @printer_class = find_printer.printer_class
        @filename = build_filename
      end

      def find_printer
        @printer_config ||= RubyProf::Rails::Printers.find_by(@type) || printer_default
      end

      def printer_default
        RubyProf::Rails::Printers.default
      end

      def build_filename
        RubyProf::Rails::Profiles.hash_to_filename(
          prefix: RubyProf::Rails::Profiles::PREFIX,
          time: Time.now.to_i,
          session_id: @request.session_options[:id],
          url: url_slice,
          format: find_printer.suffix
        )
      end

      def url_slice
        fullpath = @request.fullpath
        slice = fullpath.slice(0, 50)
        slice << '...' unless slice == fullpath
        slice
      end

    end
  end
end
