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

      def create_random_profile(num)
        FileUtils.touch(RubyProf::Rails::Config.path + filename_from(num))
      end

      def filename_from(num)
        hash_to_filename(
          prefix: RubyProf::Rails::Profiles::PREFIX,
          time: Time.now.to_i,
          session_id: Digest::SHA1.hexdigest(num.to_s),
          url: '?url=test' + num.to_s,
          format: RubyProf::Rails::Printers.formats.uniq.sample
        )
      end

    end
  end
end