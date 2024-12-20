module Api
  module V1
    module Auth
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        private

        def sign_up_params
          params_hash = params[:registration] || params
          permitted_params = params_hash.permit(:name, :user_id, :email, :password, :password_confirmation)
          Rails.logger.debug "Permitted params: #{permitted_params.inspect}"
          Rails.logger.debug "Resource errors: #{@resource&.errors&.full_messages}"
          permitted_params
        end

        def account_update_params
          params_hash = params[:registration] || params
          params_hash.permit(:name, :user_id, :email, :password, :password_confirmation, :current_password)
        end

        def render_create_error
          Rails.logger.debug "Render create error called"
          Rails.logger.debug "Resource errors: #{resource_errors}"
          render json: {
            status: "error",
            errors: resource_errors
          }, status: 422
        end

        def resource_errors
          return [] unless @resource&.errors
          @resource.errors.full_messages
        end

        protected

        def build_resource
          @resource = resource_class.new(sign_up_params)
          @resource.provider = "email"

          # uidをemailに設定（devise_token_authの要件）
          @resource.uid = sign_up_params[:email]

          Rails.logger.debug "Built resource: #{@resource.inspect}"
          Rails.logger.debug "Resource valid? #{@resource.valid?}"
          Rails.logger.debug "Resource errors: #{@resource.errors.full_messages}" unless @resource.valid?

          @resource
        end
      end
    end
  end
end
