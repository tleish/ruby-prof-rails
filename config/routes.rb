RubyProf::Rails::Engine.routes.draw do

  namespace :ruby_prof_rails do
    post '' => 'home#update'
    root to: 'home#index'
    resources :home , path: ''
    resources :profile
    resources :printer
  end

end
