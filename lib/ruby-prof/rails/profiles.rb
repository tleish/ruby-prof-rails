require_relative 'config'

module RubyProf
  module Rails
    # RubyProf Rails Profile Utility
    class Profiles

      PREFIX = 'ruby-prof-rails'

      def self.filename_hash(filename)
        regexp_hash = {
          prefix: PREFIX,
          session_id: '[^-]+',
          time: '[0-9]+',
          url: '.+',
          format: RubyProf::Rails::Printer::PRINTERS.values.uniq.join('|')
        }
        regexp = Regexp.new regexp_hash.map{|k, v| "(?<#{k}>#{v})"}.join('-')
        regexp.match filename
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
