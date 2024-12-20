Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # ユーザー関連
      resources :users, only: [:show, :update] do
        collection do
          get :current_user
          get :statistics
          patch :update_training_info
        end
        member do
          get :workout_logs
        end
      end

      # ワークアウトログ関連
      resources :workout_logs do
        collection do
          get 'daily_log/:date', to: 'workout_logs#daily_log'
          get 'weekly_log/:date', to: 'workout_logs#weekly_log'
          get 'monthly_log/:date', to: 'workout_logs#monthly_log'
          get 'yearly_log/:date', to: 'workout_logs#yearly_log'
          get 'weekly_summary/:date', to: 'workout_logs#weekly_summary'
          post :create_from_template
        end
        member do
          post :save_as_template
        end
        resources :exercises, only: [:create, :index]
      end

      # エクササイズ関連
      resources :exercises, except: [:create, :index] do
        collection do
          get 'exercise_stats/:type_of_exercise_id', to: 'exercises#exercise_stats'
          get :progress
        end
      end

      # 種目タイプ関連
      resources :type_of_exercises do
        member do
          patch :update_priority
          get 'exercise_history/:date', to: 'type_of_exercises#exercise_history'
          get 'monthly_history/:date', to: 'type_of_exercises#monthly_history'
        end
        collection do
          get :recommendations
        end
      end

      # カスタム種目タイプ関連
      resources :custom_type_of_exercises, except: [:show]

      # 認証関連
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations',
        sessions: 'api/v1/auth/sessions'
      }

      namespace :auth do
        resources :sessions, only: [:index]
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
