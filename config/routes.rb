#Define URLs and where they go to

Rails.application.routes.draw do
  #get 'password_resets/new'
  # We dont need this, it came from generating things
  #get 'password_resets/edit'
  #get 'account_activations/edit'
  #Mapping establishes that root URL will be static pgs controller, home action.
  root 'static_pages#home'

  #Sessions controller only uses named routes
  #Note that the Signup page is routed to the NEW action in users controller

  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  #GET (sessions#new) is handled with login route/path/URL to sessions controller
  #These are the 3 routes for the sessions form.
  get    '/login',   to: 'sessions#new' #RESTful conventios uses NEW for login page
  #POST request is handled by/routed to (sessions controller) create action
  post   '/login',   to: 'sessions#create' #And CREATE to complete the login
  delete '/logout',  to: 'sessions#destroy' #Destroy an object/session
  resources :users do
    # Give a block to resources :users, say member do, responding to GET requests
    # We make a route to give us that kind of URL
    member do
      get :following, :followers
    end
    # If didn't want ID in URL, EG users/tigers vs users/1/following
    #collection do
    #  get :tigers
    #end
  end
  resources :users #special resources method used to obtain full suite of RESTful routes automatically
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  #Add some routes for this, creating and destroying microposts, for mp resource
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  #Break in convention: we didn't add :new or :edit (in mp ctrlr) bc we're manipulating mp's thru user home and profile page, rather than separate views
end
