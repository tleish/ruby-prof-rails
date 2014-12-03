$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'ruby-prof/rails/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'ruby-prof-rails'
  s.version     = RubyProf::Rails::VERSION
  s.authors     = ['Thomas Leishman']
  s.email       = ['tleish@gmail.com']
  s.homepage    = 'http://github.com/tleish'
  s.summary     = 'Configure and Profile Rails applications using the ruby-prof gem.'
  s.description = %q{rails-ruby-prof is Rails Rack Middleware that allows configuration and profiling
                    of a Rails application using the ruby-prof gem for a specific session.
                    This makes it easier to profile production applications without requiring a
                    server restart or affecting other users sessions.}
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '>= 3.0'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'ruby-prof'
  s.add_dependency 'haml'
  s.add_dependency 'bootstrap-sass', '~> 3.1.1.0'
  s.add_dependency 'sass-rails', '>= 3.2'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'sinatra'
  s.add_development_dependency 'mocha'
end
