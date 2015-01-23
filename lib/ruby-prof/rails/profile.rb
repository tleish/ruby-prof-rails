require 'yaml'
require_relative 'printers'

module RubyProf
  module Rails
    # RubyProf Rails Profile Utility
    class Profile

      ID_PATTERN = [:time, :session_id]

      attr_reader :filename, :manifest

      def initialize(manifest_filename)
        @manifest = manifest_filename
        @filename = RubyProf::Rails::Config.path + hash[:filename]
      end

      def exists?
        File.exist?(@filename)
      end

      def basename
        File.basename(@filename)
      end

      def friendly_filename
        time = Time.at(hash[:time].to_i).strftime('%Y-%m-%d_%H-%M-%S-%Z')
        "#{hash[:prefix]}_#{time}.#{hash[:format]}"
      end

      def time
        Time.at(hash[:time].to_i)
      end

      def friendly_time
        time.strftime('%Y-%m-%d %I:%M:%S %Z')
      end

      def session_id
        hash[:session_id]
      end

      def id
        hash.slice(*ID_PATTERN).values.join('-')
      end

      def url
        hash[:url]
      end

      def hash
        @hash ||= YAML::load_file @manifest
      end

      def printer
        RubyProf::Rails::Printers.find_type_by(hash[:format])
      end

    end
  end
end