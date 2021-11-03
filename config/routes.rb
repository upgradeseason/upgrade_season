# Define URLs and where they go to

Rails.application.routes.draw do
  # This mapping establishes that the root URL will be static_pages controller, home action.
  root 'static_pages#home'

  # The sessions_controller only uses named routes

  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  # The Signup page is routed to the NEW action in users controller
  get    '/signup',  to: 'users#new'
  # GET (sessions#new) is handled with login route/path/URL to the sessions controller
  #These are the 3 routes for the sessions form.
  get    '/login',   to: 'sessions#new' #RESTful conventios uses NEW for login page
  #The POST request is handled by and routed to the sessions controller create action
  post   '/login',   to: 'sessions#create' # CREATE completes the login
  delete '/logout',  to: 'sessions#destroy' # Destroy an object/session
  resources :users do
    # Give a block to resources :users, 'member do' responds to GET requests
    # We make a route to give us that kind of URL
    member do
      get :following, :followers
    end

    # If we didn't want the ID in the URL, EG users/tigers vs users/1/following we write
    #collection do
    # get :tigers
    #end
  end
  resources :users # Special resources method used to obtain the full suite of RESTful routes automatically
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  # Add some routes for this, creating and destroying microposts, for micropost resource
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  # Break in convention: we didn't add :new or :edit (in micropost controller) bc we're manipulating
  # Microposts through the user home and profile page, rather than separate views
end
