RhinobirdApi::Application.routes.draw do

  namespace :api, defaults: {format: :json} do

    devise_for :users, singular: :user, controllers: {
      confirmations: "api/confirmations",
      passwords: "api/passwords",
      omniauth_callbacks: "api/omniauth_callbacks",
      registrations: "api/users"}

    devise_scope :user do
      post 'users' => 'users#create', as: 'register', defaults: {format: :json}
      post 'sessions' => 'sessions#create', :as => 'login', defaults: {format: :json}
      get 'sessions/current' => 'sessions#show', :as => 'show', defaults: {format: :json}
      delete 'sessions/current' => 'sessions#destroy', :as => 'logout', defaults: {format: :json}
    end
    resources :users, only: [:show, :update, :create, :index],  constraints: { :id => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/ } do
      resources :streams, only: [:index]
      resources :streams_pool, only: [:index]
    end

    #stream_pool routes
    resources :streams_pool, only: [:create, :index, :destroy, :update]

    resources :channels, only: [:create, :show, :index, :destroy] do
      resources :streams, only: [:index]
    end

    resources :streams, only: [:create, :show, :index, :destroy, :update] do
      resources :tags, only: [:create, :destroy]
      member do
        put :play
        get :related
      end
    end

  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
