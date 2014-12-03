module RubyProf
  module Rails
    # server configuration for RubyProfRails application
    class Config
      class << self
        attr_accessor :username, :password, :content_types, :path

        def path
          @path = ::Rails.root + 'tmp/performance' if @path.blank?
          Pathname(@path)
        end

        def content_types
          @content_types = 'text/html' if @content_types.blank?
          Array(@content_types)
        end

        def extract_options_from(env)
          Hash(env['rack.session'][:ruby_prof_rails])
        end

        def has_authentication?
          RubyProf::Rails::Config.username.present? || RubyProf::Rails::Config.password.present?
        end

      end
    end
  end
end
