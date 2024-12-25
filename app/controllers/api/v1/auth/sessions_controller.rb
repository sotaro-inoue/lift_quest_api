# frozen_string_literal: true

module API
  module V1
    module Auth
      class SessionsController < ::DeviseTokenAuth::SessionsController
        def create
          Rails.logger.debug "Original params: #{params.inspect}"

          if params[:identifier].present?
            if params[:identifier].start_with?("@")
              @resource = User.find_by(user_id: params[:identifier])
            else
              @resource = User.find_by(email: params[:identifier])
            end
          end

          if @resource && @resource.valid_password?(params[:password])
            Rails.logger.debug "Password is valid"

            # DeviseTokenAuthの標準的な方法でトークンを生成
            @token = @resource.create_token
            @resource.save!

            # レスポンスヘッダーにトークン情報を設定
            response.headers.merge!(@resource.build_auth_header(@token.token, @token.client))

            render json: {
              data: {
                id: @resource.id,
                name: @resource.name,
                user_id: @resource.user_id,
                email: @resource.email
              },
              success: true
            }
          else
            render json: {
              success: false,
              errors: [ "メールアドレス/ユーザーIDまたはパスワードが正しくありません" ]
            }, status: 401
          end
        end

        private

        def sign_in_params
          params.permit(:identifier, :password)
        end
      end
    end
  end
end
