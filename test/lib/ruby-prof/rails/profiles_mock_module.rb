require './lib/ruby-prof/rails/config'
require './lib/ruby-prof/rails/profiles'
require './lib/ruby-prof/rails/printers'
require './lib/ruby-prof/rails/filename_module'
require 'digest/sha1'
require 'fileutils'

module RubyProf
  module Rails
    module ProfilesMockModule

      include RubyProf::Rails::FilenameModule

      private

      def cleanup_profiles
        dir_path = RubyProf::Rails::Config.path
        keep_path = Pathname.new(dir_path + '.keep')
        Pathname.new(dir_path).children.each do |file|
          file.unlink unless file == keep_path
        end
      end

      def create_random_profiles
        (1..10).each do |num|
          create_random_profile(num)
        end
        RubyProf::Rails::Profiles.list
      end

      def create_random_profile
        filename = RubyProf::Rails::Config.path + "#{hash_to_filename}"
        FileUtils.touch(filename)
        File.open("#{filename}.yml", 'w+') do |file|
          file.write mock_filename_hash.to_yaml
        end
        "#{filename}.yml"
      end

      def mock_filename_hash
        file_hash.merge(
          filename: RubyProf::Rails::Config.path + hash_to_filename
        )
      end

      def mock_request
        OpenStruct.new(
          session_options: {id: 1234}
        )
      end

      def find_printer
        type = RubyProf::Rails::Printers.types.uniq.sample
        RubyProf::Rails::Printers.find_by(type)
      end

    end
  end
end