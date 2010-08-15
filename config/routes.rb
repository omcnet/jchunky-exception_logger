Rails.application.routes.draw do

  # Exception Logger
  resources :logged_exceptions do
    collection do
      post :query
      post :destroy_all
    end
  end
  
end