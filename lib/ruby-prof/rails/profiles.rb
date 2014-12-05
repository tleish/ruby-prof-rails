require_relative 'config'

module RubyProf
  module Rails
    # RubyProf Rails Profile Utility
    class Profiles

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

      def self.filename_to_hash(filename)
        regexp_hash = REGEXP_HASH
        regexp_hash[:format] = RubyProf::Rails::Printer::PRINTERS.values.uniq.join('|')
        regexp = Regexp.new regexp_hash.map{|k, v| "(?<#{k}>#{v})"}.join('-')
        match_data = regexp.match(filename)
        match_data.present? && match_data.to_hash || INVALID_FILENAME
      end

      def self.hash_to_filename(hash)
        name = REGEXP_HASH.keys.map { |key| hash.fetch(key)}
        CGI::escape(name.join('-'))
      end

      def self.list
        Dir[File.join(RubyProf::Rails::Config.path, "#{PREFIX}*")]
      end

      def self.get_id(filename)
        file_hash = filename_to_hash(filename)
        file_hash.slice(ID_PATTERN).values.join('-')
      end

      def self.find(id)
        profiles = RubyProf::Rails::Profiles.list
        profiles.detect do |path|
          file = File.basename(path)
          file =~ /^#{PREFIX}-#{id}/
        end
      end

    end
  end
end

class MatchData
  def to_hash
    Hash[ names.zip(captures) ].symbolize_keys
  end
end
