Rails.application.routes.draw do

  namespace :ruby_prof, path: 'ruby_prof_rails' do
    namespace :rails, path: '' do
      post '' => 'home#update'
      resources :home, path: ''
    end
  end

end
