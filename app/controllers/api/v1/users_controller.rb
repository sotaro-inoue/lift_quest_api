module API
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :ensure_correct_user, only: [ :update, :statistics ]

      def current_user
        render json: current_api_v1_user, include: :workout_logs
      end

      def update
        if current_api_v1_user.update(user_params)
          render json: current_api_v1_user
        else
          render json: current_api_v1_user.errors, status: :unprocessable_entity
        end
      end

      def statistics
        start_date = params[:start_date]&.to_date || 30.days.ago.to_date
        end_date = params[:end_date]&.to_date || Date.current

        @stats = {
          total_workouts: current_api_v1_user.workout_logs.where(created_at: start_date..end_date).count,
          total_exercises: current_api_v1_user.exercises.where(created_at: start_date..end_date).count,
          favorite_exercises: current_api_v1_user.exercises
                            .where(created_at: start_date..end_date)
                            .group(:type_of_exercise_id)
                            .count
                            .sort_by { |_, v| -v }
                            .take(5),
          streak: calculate_workout_streak
        }

        render json: @stats
      end

      def me
        render json: {
          id: current_api_v1_user.id,
          email: current_api_v1_user.email,
          user_id: current_api_v1_user.user_id,
          name: current_api_v1_user.name
        }
      end

      def workout_logs
        @user = User.find(params[:id])
        @workout_logs = @user.workout_logs
        render json: @workout_logs
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :user_id, :experience_level, :training_goal)
      end

      def calculate_workout_streak
        current_streak = 0
        date = Date.current

        while current_api_v1_user.workout_logs.where(created_at: date.all_day).exists?
          current_streak += 1
          date = date.prev_day
        end

        current_streak
      end

      def ensure_correct_user
        user = User.find_by!(user_id: params[:id])
        unless user == current_api_v1_user
          render json: { error: "権限がありません" }, status: :forbidden
        end
      end

      def update_training_info
        if current_api_v1_user.update(training_info_params)
          render json: current_api_v1_user
        else
          Rails.logger.error(current_api_v1_user.errors.full_messages)
          render json: { errors: current_api_v1_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        user = User.find_by!(user_id: params[:id])
        render json: {
          id: user.id,
          email: user.email,
          user_id: user.user_id
        }
      end
    end
  end
end
