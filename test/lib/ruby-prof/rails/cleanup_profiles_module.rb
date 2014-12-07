require './lib/ruby-prof/rails/config'

module RubyProf
  module Rails
    module CleanupProfilesModule
      private

      def cleanup_profiles
        dir_path = RubyProf::Rails::Config.path
        keep_path = Pathname.new(dir_path + '.keep')
        Pathname.new(dir_path).children.each do |file|
          file.unlink unless file == keep_path
        end
      end
    end
  end
end