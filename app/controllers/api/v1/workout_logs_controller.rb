class Api::V1::WorkoutLogsController < ApplicationController
  def index
    @workout_logs = WorkoutLog.all
    render json: @workout_logs
  end

  def show
    @workout_log = WorkoutLog.find(params[:id])
    render json: @workout_log
  end

  def create
    @workout_log = WorkoutLog.new(workout_log_params)
    if @workout_log.save
      render json: @workout_log, status: :created
    else
      render json: @workout_log.errors, status: :unprocessable_entity
    end
  end

  def update
    @workout_log = WorkoutLog.find(params[:id])
    if @workout_log.update(workout_log_params)
      render json: @workout_log
    else
      render json: @workout_log.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @workout_log = WorkoutLog.find(params[:id])
    @workout_log.destroy
    head :no_content
  end

  private

  def workout_log_params
    params.require(:workout_log).permit(:exercise_name, :type_of_exercise, :weight, :reps, :sets)
  end

end