class Api::V1::ExercisesController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_workout_log, only: [:create, :index]
  before_action :set_exercise, only: [:show, :update, :destroy]
  before_action :authorize_exercise, only: [:update, :destroy]
  
  def index
    @exercises = if params[:workout_log_id]
                  @workout_log.exercises
                elsif params[:type_of_exercise_id]
                  type = TypeOfExercise.find(params[:type_of_exercise_id])
                  custom_type = current_api_v1_user.custom_type_of_exercises
                                .find_by(type_of_exercise: type)
                  Exercise.where(type_of_exercise: type)
                         .or(Exercise.where(custom_type_of_exercise: custom_type))
                else
                  current_api_v1_user.exercises
                end
    render json: @exercises
  end

  def show
    render json: @exercise
  end

  def create
    @exercise = @workout_log.exercises.build(exercise_params)
    
    if @exercise.save
      render json: @exercise, status: :created
    else
      render json: @exercise.errors, status: :unprocessable_entity
    end
  end

  def update
    if @exercise.update(exercise_params)
      render json: @exercise
    else
      render json: @exercise.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @exercise.destroy
    head :no_content
  end

  def exercise_stats
    @exercise_type = TypeOfExercise.find(params[:type_of_exercise_id])
    
    @stats = current_api_v1_user.exercises
              .where(type_of_exercise: @exercise_type)
              .group(:type_of_exercise_id)
              .select(
                'MAX(weight) as max_weight',
                'MAX(reps) as max_reps',
                'SUM(weight * reps * sets) as total_volume'
              )
              
    render json: {
      type_of_exercise: @exercise_type,
      max_weight: @stats.first&.max_weight,
      max_reps: @stats.first&.max_reps,
      total_volume: @stats.first&.total_volume
    }
  end

  def progress
    @exercise_type = TypeOfExercise.find(params[:type_of_exercise_id])
    start_date = params[:start_date].to_date
    end_date = params[:end_date].to_date

    @progress = current_api_v1_user.exercises
                 .where(type_of_exercise: @exercise_type)
                 .where(created_at: start_date..end_date)
                 .group("DATE(created_at)")
                 .select(
                   "DATE(created_at) as date",
                   "MAX(weight) as max_weight",
                   "SUM(weight * reps * sets) as volume"
                 )
                 .order("date")

    render json: @progress
  end

  private

  def set_workout_log
    @workout_log = current_api_v1_user.workout_logs.find(params[:workout_log_id])
  end

  def set_exercise
    @exercise = Exercise.find(params[:id])
  end

  def exercise_params
    params.require(:exercise).permit(
      :type_of_exercise_id,
      :custom_type_of_exercise_id,
      :weight,
      :reps,
      :sets
    )
  end

  def authorize_exercise
    unless @exercise.workout_log.user == current_api_v1_user
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
