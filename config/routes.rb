Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :bands do
    resources :albums
  end

  get '/repo/changed_files', to: 'repo#changed_files'

end
