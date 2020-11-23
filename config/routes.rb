#Define URLs and where the go to

Rails.application.routes.draw do
  root 'static_pages#home'

  #get 'sessions/new' #only uses named routes(GET and POST handled with #login route, DELETE with #logout route.
  #get 'users/new'

  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users #special resources method used to obtain full suite of RESTful routes automatically
end
