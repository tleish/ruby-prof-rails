Rails.application.routes.draw do
  mount RubyProf::Rails::Engine => "/ruby_prof_rails"
end
