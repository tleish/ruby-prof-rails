require_relative 'config'
require 'ostruct'

module RubyProf
  module Rails
    # RubyProf Rails Profile Utility
    class Profiles

      attr_reader :filename, :friendly_filename

      PREFIX = 'ruby-prof-rails'

      REGEXP_HASH = {
        prefix: PREFIX,
        time: '[0-9]+',
        session_id: '[^-]+',
        url: '.+',
        format: nil
      }

      INVALID_FILENAME = {
        prefix: PREFIX,
        time: 'NA',
        url: 'NA',
        format: 'NA'
      }

      ID_PATTERN = [:time, :session_id]

      class << self
        def hash_to_filename(hash)
          name = REGEXP_HASH.keys.map { |key| hash.fetch(key)}
          CGI::escape(name.join('-'))
        end

        def list
          Dir[File.join(RubyProf::Rails::Config.path, "#{PREFIX}*")].map do |file|
            self.new(file)
          end
        end

        def find(id)
          profiles = RubyProf::Rails::Profiles.list
          profiles.detect { |profile| profile.id == id }
        end
      end

      def initialize(filename)
        @filename = filename
        @friendly_filename = friendly_filename
      end

      def exists?
        File.exist?(@filename)
      end

      def basename
        File.basename(@filename)
      end

      def friendly_filename
        time = Time.at(hash[:time].to_i).strftime('%Y-%m-%d_%I-%M-%S-%Z')
        "#{PREFIX}_#{time}.#{hash[:format]}"
      end

      def id
        hash.slice(ID_PATTERN).values.join('-')
      end

      def hash
        regexp_hash = REGEXP_HASH
        regexp_hash[:format] = RubyProf::Rails::Printer::PRINTERS.values.uniq.join('|')
        regexp = Regexp.new regexp_hash.map{|k, v| "(?<#{k}>#{v})"}.join('-')
        match_data = regexp.match(basename)
        match_data.present? && match_data.to_hash || INVALID_FILENAME
      end

    end
  end
end

class MatchData
  def to_hash
    Hash[ names.zip(captures) ].symbolize_keys
  end
end
