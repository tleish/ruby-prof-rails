require 'yaml'

module RubyProf
  module Rails
    # RubyProf Rails Profile Utility
    class Profile

      ID_PATTERN = [:time, :session_id]

      attr_reader :filename

      def initialize(manifest_filename)
        @manifest = manifest_filename
        @filename = hash[:filename]
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

      def id
        hash.slice(*ID_PATTERN).values.join('-')
      end

      def hash
        @hash ||= YAML::load_file @manifest
      end

    end
  end
end