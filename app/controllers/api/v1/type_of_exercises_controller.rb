class Api::V1::TypeOfExercisesController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    @type_of_exercises = TypeOfExercise
                          .order(:name)
                          .page(params[:page])
                          .per(50)  # 1ページあたり50件

    if params[:query].present?
      @type_of_exercises = @type_of_exercises
                            .where('name LIKE ?', "%#{params[:query]}%")
    end

    render json: @type_of_exercises
  end

  def show
    @type_of_exercise = TypeOfExercise.find(params[:id])
    render json: @type_of_exercise
  end

  def create
    @type_of_exercise = TypeOfExercise.new(type_of_exercise_params)
    if @type_of_exercise.save
      render json: @type_of_exercise, status: :created
    else
      render json: @type_of_exercise.errors, status: :unprocessable_entity
    end
  end

  def update
    @type_of_exercise = TypeOfExercise.find(params[:id])
    if @type_of_exercise.update(type_of_exercise_params)
      render json: @type_of_exercise
    else
      render json: @type_of_exercise.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @type_of_exercise = TypeOfExercise.find(params[:id])
    @type_of_exercise.destroy
    head :no_content
  end

  def monthly_history
    @type_of_exercise = TypeOfExercise.find(params[:id])
    start_date = params[:date].to_date.beginning_of_month
    end_date = start_date.end_of_month

    @exercises = current_api_v1_user.exercises
                  .where(type_of_exercise: @type_of_exercise)
                  .where(created_at: start_date..end_date)
                  .includes(:workout_log)
                  .order(created_at: :desc)

    render json: {
      type_of_exercise: @type_of_exercise,
      month: start_date.strftime("%Y年%m月"),
      exercise_count: @exercises.count,
      exercises: @exercises.map { |exercise|
        {
          date: exercise.created_at.strftime("%Y-%m-%d"),
          weight: exercise.weight,
          reps: exercise.reps,
          sets: exercise.sets,
          workout_log_id: exercise.workout_log_id
        }
      }
    }
  end

  def exercise_history
    @type_of_exercise = TypeOfExercise.find(params[:id])
    period = params[:period] || 'daily'  # daily, weekly, monthly, yearly
    date = params[:date].to_date
    
    range = case period
            when 'daily'   then date.beginning_of_day..date.end_of_day
            when 'weekly'  then date.beginning_of_week..date.end_of_week
            when 'monthly' then date.beginning_of_month..date.end_of_month
            when 'yearly'  then date.beginning_of_year..date.end_of_year
            end

    @exercises = current_api_v1_user.exercises
                  .where(type_of_exercise: @type_of_exercise)
                  .where(created_at: range)
                  .includes(:workout_log)
                  .order(created_at: :desc)

    render json: {
      type_of_exercise: @type_of_exercise,
      period: period,
      start_date: range.begin,
      end_date: range.end,
      exercise_count: @exercises.count,
      exercises: @exercises.map { |exercise|
        {
          date: exercise.created_at.strftime("%Y-%m-%d"),
          weight: exercise.weight,
          reps: exercise.reps,
          sets: exercise.sets,
          workout_log_id: exercise.workout_log_id
        }
      }
    }
  end

  def recommendations
    @recent_exercises = current_api_v1_user.exercises
                         .includes(:type_of_exercise)
                         .order(created_at: :desc)
                         .limit(10)
                         .pluck(:type_of_exercise_id)

    # 全ての利用可能な種目を取得し、ユーザーに応じた優先度を計算
    available_exercises = TypeOfExercise
                           .where.not(id: @recent_exercises)
                           .map { |exercise| 
                             [exercise, exercise.calculate_priority_for_user(current_api_v1_user)]
                           }
                           .sort_by { |_, priority| -priority }

    # 優先度に基づいて種目を分類
    @recommendations = {
      high_priority: available_exercises.take(3).map(&:first),
      medium_priority: available_exercises[3..5].to_a.map(&:first),
      other: available_exercises[6..7].to_a.map(&:first)
    }

    render json: @recommendations
  end

  def update_priority
    @type_of_exercise = TypeOfExercise.find(params[:id])
    
    if @type_of_exercise.update(priority: params[:priority])
      render json: @type_of_exercise
    else
      render json: @type_of_exercise.errors, status: :unprocessable_entity
    end
  end
end
