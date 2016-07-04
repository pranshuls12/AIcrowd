require 'sidekiq/web'
require 'sidetiq/web'

Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'

  get 'markdown_editor/create'
  get 'markdown_editor/show'

  devise_for :participants
  resources :participants, only: [:show, :edit, :update, :destroy] do
    get :sync_mailchimp
  end

  # Administrate
  namespace :admin do
    resources :articles
    resources :article_sections
    resources :comments
    resources :participants
    resources :challenges, except: [:edit]
    resources :images
    resources :dataset_files
    resources :organizers
    resources :submissions
    resources :submission_files
    resources :submission_grades
    resources :posts
    resources :events
    resources :topics
    resources :votes
    resources :dataset_file_downloads
    resources :leaderboards, only: :index
    root to: 'participants#index'
  end

  # API
  namespace :api do
    namespace :v1 do
      resources :submissions, only: [:update]
    end
  end

  get 'markdown_editor/show'

  get 'landing_page/index'  # TODO refactor

  resources :organizers do
    resources :challenges
  end

  resources :challenges do
    resources :dataset_files, except: [:show]
    resources :events
    resources :submissions, except: [ :edit, :update ] do
      get :grade
    end
    resources :leaderboards, only: [:index]
    resources :topics
  end

  resources :dataset_files, except: [:show] do
    resources :dataset_file_downloads, only: [:create]
  end

  resources :topics do
    resources :posts, only: [:new, :create, :edit, :update, :destroy]
  end

  resources :posts do
    resources :votes, only: [:create, :destroy]
  end

  resources :submissions do
    resources :votes, only: [:create, :destroy]
  end

  resources :articles do
    resources :article_sections
    resources :votes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end


  get '/pages/*id' => 'pages#show', as: :page, format: false

  root 'challenges#index', as: :authenticated_root
end
