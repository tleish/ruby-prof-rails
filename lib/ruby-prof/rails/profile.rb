require_relative 'filename_module'

module RubyProf
  module Rails
    # RubyProf Rails Profile Utility
    class Profile

      attr_reader :filename

      include RubyProf::Rails::FilenameModule

      def initialize(filename)
        @filename = filename
        @printers = RubyProf::Rails::Printers
      end

      def exists?
        File.exist?(@filename)
      end

      def basename
        File.basename(@filename)
      end

      def friendly_filename
        time = Time.at(hash[:time].to_i).strftime('%Y-%m-%d_%H-%M-%S-%Z')
        "#{PREFIX}_#{time}.#{hash[:format]}"
      end

      def time
        Time.at(hash[:time].to_i)
      end

      def id
        hash.slice(*ID_PATTERN).values.join('-')
      end

      def hash
        @hash ||= begin
          hash = filename_to_hash
          hash[:printer] = @printers.find_type_by(hash[:format])
          hash[:url] = CGI::unescape(hash[:url]) if hash[:url]
          hash
        end
      end

    end
  end
end