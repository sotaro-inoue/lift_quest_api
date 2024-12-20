module Api
  module V1
    module Auth
      class SessionsController < DeviseTokenAuth::SessionsController
        private

        def resource_params
          params.permit(:email, :password)
        end

        def find_resource(field, value)
          # メールアドレスまたはユーザーIDでユーザーを検索
          if field == 'email'
            @resource = resource_class.find_by(email: value)
            @resource ||= resource_class.find_by(user_id: value)
          else
            @resource = resource_class.find_by(field => value)
          end
        end

        def render_create_error_bad_credentials
          render json: {
            errors: ['メールアドレス/ユーザーIDまたはパスワードが正しくありません']
          }, status: 401
        end
      end
    end
  end
end
