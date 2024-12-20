class Api::V1::CustomTypeOfExercisesController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_custom_type, only: [:update, :destroy]

  def index
    @custom_types = current_api_v1_user.custom_type_of_exercises
                    .includes(:type_of_exercise)
                    .order(:name)
                    .page(params[:page])
                    .per(50)

    if params[:query].present?
      @custom_types = @custom_types.where('custom_type_of_exercises.name LIKE ?', "%#{params[:query]}%")
    end

    render json: @custom_types, include: :type_of_exercise
  end

  def create
    @custom_type = current_api_v1_user.custom_type_of_exercises.build(custom_type_params)
    
    if @custom_type.save
      render json: @custom_type, status: :created
    else
      render json: @custom_type.errors, status: :unprocessable_entity
    end
  end

  def update
    if @custom_type.update(custom_type_params)
      render json: @custom_type
    else
      render json: @custom_type.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @custom_type.destroy
    head :no_content
  end

  private

  def set_custom_type
    @custom_type = current_api_v1_user.custom_type_of_exercises.find(params[:id])
  end

  def custom_type_params
    params.require(:custom_type_of_exercise).permit(:name, :type_of_exercise_id)
  end
end 