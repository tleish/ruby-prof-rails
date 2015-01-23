module RubyProf
  module Rails
    # RubyProf Rails FilenameHash Methods
    module FilenameModule

      PREFIX = 'ruby-prof-rails'

      REGEXP_HASH = {
        prefix: PREFIX,
        time: '[0-9]+',
        session_id: '[^-]+',
      format: nil
      }

      INVALID_FILENAME = {
        prefix: PREFIX,
        time: 'NA',
        format: 'NA'
      }

      ID_PATTERN = [:time, :session_id]

      def self.included(base)
        base.const_set :PREFIX, RubyProf::Rails::FilenameModule::PREFIX
      end

      def file_hash
        @file_hash ||= {
          prefix: PREFIX,
          time: Time.now.to_i,
          session_id: @request.session_options[:id],
          format: find_printer.suffix,
        }
      end

      private

      def hash_to_filename
        name = REGEXP_HASH.keys.map { |key| file_hash.fetch(key)}
        CGI::escape(name.join('-'))
      end

    end
  end
end

class MatchData
  def to_hash
    Hash[ names.zip(captures) ].symbolize_keys
  end
end
