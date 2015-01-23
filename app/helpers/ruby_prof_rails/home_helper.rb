module RubyProfRails
  module HomeHelper

    def my_profiles
      @profiles.select { |profile| profile.session_id == request.session_options[:id] }
    end

  end
end
