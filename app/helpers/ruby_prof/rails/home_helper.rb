module RubyProf
  module Rails
    module HomeHelper

      def file_hash_from(file)
        filename = CGI::unescape(File.basename(file))
        RubyProf::Rails::Profiles.filename_hash(filename)
      end

      def parse_date_time(string)
        regexp = /(?<year>[0-9]{4})-(?<month>[0-9]{2})-(?<day>[0-9]{2})-(?<hour>[0-9]{2})-(?<min>[0-9]{2})-(?<sec>[0-9]{2})-(?<zone>[A-Z]+)/
        time = regexp.match string
        "#{time}"
      end

      def parse_id(file)
        file_hash = file_hash_from(file)
        "#{file_hash[:session_id]}-#{file_hash[:time]}"
      end

      def display_name_from(file)
        file_hash = file_hash_from(file)
        "#{file_hash[:time]} - #{file_hash[:url]} - #{file_hash[:format]}"
      end

    end
  end
end
