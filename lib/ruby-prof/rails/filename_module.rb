module RubyProf
  module Rails
    # RubyProf Rails FilenameHash Methods
    module FilenameModule

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

      def self.included(base)
        base.const_set :PREFIX, RubyProf::Rails::FilenameModule::PREFIX
      end

      private

      def filename_to_hash
        regexp_hash = REGEXP_HASH
        regexp_hash[:format] = @printers.formats.uniq.join('|')
        regexp = Regexp.new regexp_hash.map{|k, v| "(?<#{k}>#{v})"}.join('-')
        match_data = regexp.match(basename)
        match_data.present? && match_data.to_hash || INVALID_FILENAME
      end

      def hash_to_filename(hash)
        name = REGEXP_HASH.keys.map { |key| hash.fetch(key)}
        CGI::escape(name.join('-'))
      end

      def build_filename
        hash_to_filename(
          prefix: PREFIX,
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

class MatchData
  def to_hash
    Hash[ names.zip(captures) ].symbolize_keys
  end
end
