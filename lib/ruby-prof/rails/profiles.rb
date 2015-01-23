require_relative 'config'
require_relative 'profile'
require_relative 'filename_module'

module RubyProf
  module Rails
    # RubyProf Rails Profile Utility
    class Profiles

      include RubyProf::Rails::FilenameModule

      class << self
        def list
          Dir[File.join(RubyProf::Rails::Config.path, "#{PREFIX}*.yml")].reverse.map do |file|
            RubyProf::Rails::Profile.new(file)
          end
        end

        def find(id)
          profiles = self.list
          profile = profiles.detect { |profile| profile.id == id }
          return profile if profile && profile.exists?
        end
      end

    end
  end
end
