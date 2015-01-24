RubyProf::Rails::Engine.routes.draw do

  namespace :ruby_prof_rails do
    post '' => 'home#update'
    root to: 'home#index'
    resources :home , path: ''
    post 'profile' => 'profile#batch', :as => :profile_batch
    resources :profile
    resources :printer

  end

end
