class Api::V1::WorkoutLogsController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_workout_log, only: [:show, :update, :destroy]
  before_action :authorize_workout_log, only: [:show, :update, :destroy]

  def index
    @workout_logs = current_api_v1_user.workout_logs
                  .order(created_at: :desc)
                  .page(params[:page])
                  .per(20)
    render json: @workout_logs, include: :exercises
  end

  def show
    render json: @workout_log, include: {
      exercises: {
        include: :type_of_exercise
      }
    }
  end

  def create
    @workout_log = current_api_v1_user.workout_logs.build(workout_log_params)
    if @workout_log.save
      render json: @workout_log, status: :created
    else
      render json: @workout_log.errors, status: :unprocessable_entity
    end
  end

  def update
    if @workout_log.update(workout_log_params)
      render json: @workout_log
    else
      render json: @workout_log.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @workout_log.destroy
    head :no_content
  end

  #1日の記録を取得
  def daily_log
    date = params[:date].to_date
    @workout_log = current_api_v1_user.workout_logs
                    .where(created_at: date.beginning_of_day..date.end_of_day)
                    .first
    
    if @workout_log
      render json: @workout_log, include: {
        exercises: {
          include: :type_of_exercise
        }
      }
    else
      render json: { message: "No workout log found for this date" }, status: :not_found
    end
  end
  #1週間の記録を取得
  def weekly_log
    date = params[:date].to_date
    @workout_logs = current_api_v1_user.workout_logs
                    .where(created_at: date.beginning_of_week..date.end_of_week)
                    .order(created_at: :desc)
                    .page(params[:page])
                    .per(20)
    render json: @workout_logs, include: :exercises
  end

  #1ヶ月の記録を取得
  def monthly_log
    date = params[:date].to_date
    @workout_logs = current_api_v1_user.workout_logs
                    .where(created_at: date.beginning_of_month..date.end_of_month)
                    .order(created_at: :desc)
                    .page(params[:page])
                    .per(20)
    render json: @workout_logs, include: :exercises
  end

  #1年間の記録を取得
  def yearly_log
    date = params[:date].to_date
    @workout_logs = current_api_v1_user.workout_logs
                    .where(created_at: date.beginning_of_year..date.end_of_year)
                    .order(created_at: :desc)
                    .page(params[:page])
                    .per(20)
    render json: @workout_logs, include: :exercises
  end

  def weekly_summary
    start_date = params[:date].to_date.beginning_of_week
    end_date = start_date.end_of_week
    
    @workout_logs = current_api_v1_user.workout_logs
                    .where(created_at: start_date..end_date)
                    .includes(exercises: :type_of_exercise)
    
    render json: {
      start_date: start_date,
      end_date: end_date,
      workout_count: @workout_logs.count,
      workout_logs: @workout_logs
    }
  end

  # テンプレートとしてワークアウトを保存
  def save_as_template
    @workout_log = WorkoutLog.find(params[:id])
    @template = current_api_v1_user.workout_templates.create(
      name: params[:template_name],
      exercises_attributes: @workout_log.exercises.map(&:attributes)
    )

    render json: @template, status: :created
  end

  # テンプレートからワークアウトを作成
  def create_from_template
    @template = current_api_v1_user.workout_templates.find(params[:template_id])
    @workout_log = current_api_v1_user.workout_logs.create(
      exercises_attributes: @template.exercises.map(&:attributes)
    )

    render json: @workout_log, status: :created
  end

  private

  def set_workout_log
    @workout_log = WorkoutLog.find(params[:id])
  end

  def authorize_workout_log
    unless @workout_log.user == current_api_v1_user
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
