Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :resources do
    collection do
      post :destroy_multiple
    end
  end

  get 'music_admin', to: 'resources#music_index'
  get 'music_upload', to: 'resources#music_upload'
  get 'access_denied', to: 'resources#access_denied'
  root 'resources#home'
end
