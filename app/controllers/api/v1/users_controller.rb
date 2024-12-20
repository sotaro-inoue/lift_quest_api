class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_v1_user!
  
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

  def update_training_info
    if current_api_v1_user.update(training_info_params)
      render json: current_api_v1_user
    else
      Rails.logger.error(current_api_v1_user.errors.full_messages)
      render json: { errors: current_api_v1_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
  
  def show
    @user = User.find(params[:id])
    render json: @user, include: :workout_logs
  end

  def workout_logs
    @user = User.find(params[:id])
    @workout_logs = @user.workout_logs
    render json: @workout_logs
  end

  def calculate_workout_streak
    # 連続トレーニング日数を計算
    current_streak = 0
    date = Date.current

    while current_api_v1_user.workout_logs.where(created_at: date.all_day).exists?
      current_streak += 1
      date = date.prev_day
    end

    current_streak
  end

  def training_info_params
    # パラメータをログに出力して問題を特定
    Rails.logger.debug("Training info params: #{params.inspect}")
    params.require(:user).permit(:experience_level, :training_goal)
  end
end