module Api
  module V1
    module Auth
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        private

        def sign_up_params
          Rails.logger.debug "Registration params: #{params.inspect}"
          params.permit(:name, :user_id, :email, :password)
        end

        def account_update_params
          params.permit(:name, :user_id, :email, :password, :current_password)
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
          signup_attributes = sign_up_params
          @resource = resource_class.new(signup_attributes)
          @resource.provider = "email"
          @resource.uid = signup_attributes[:email]

          Rails.logger.debug "Built resource: #{@resource.inspect}"
          Rails.logger.debug "Resource valid? #{@resource.valid?}"
          Rails.logger.debug "Resource errors: #{@resource.errors.full_messages}" unless @resource.valid?

          @resource
        end
      end
    end
  end
end
