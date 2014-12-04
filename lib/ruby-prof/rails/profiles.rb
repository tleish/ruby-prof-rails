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

      def self.filename_to_hash(filename)
        regexp_hash = REGEXP_HASH
        regexp_hash[:format] = RubyProf::Rails::Printer::PRINTERS.values.uniq.join('|')
        regexp = Regexp.new regexp_hash.map{|k, v| "(?<#{k}>#{v})"}.join('-')
        regexp.match(filename) || INVALID_FILENAME
      end

      def self.hash_to_filename(hash)
        name = REGEXP_HASH.keys.map { |key| hash.fetch(key)}
        CGI::escape(name.join('-'))
      end

      def self.list
        Dir[File.join(RubyProf::Rails::Config.path, "#{PREFIX}*")]
      end

      def self.find(session_time)
        profiles = RubyProf::Rails::Profiles.list
        profiles.detect do |path|
          file = File.basename(path)
          file =~ /^#{PREFIX}-#{session_time}/
        end
      end

    end
  end
end
