class Exercise < ApplicationRecord
  belongs_to :workout_log
  belongs_to :type_of_exercise, optional: true
  belongs_to :custom_type_of_exercise, optional: true
  has_one :user, through: :workout_log

  validates :exercise_name, presence: true  
  validates :weight, presence: true, numericality: { greater_than: 0 }  
  validates :reps, presence: true, numericality: { greater_than: 0 }
  validates :sets, presence: true, numericality: { greater_than: 0 }
  validates :workout_log_id, presence: true
  validates :type_of_exercise_id, presence: true

  private

  def must_have_type_reference
    unless type_of_exercise.present? || custom_type_of_exercise.present?
      errors.add(:base, "Must reference either type_of_exercise or custom_type_of_exercise")
    end
  end
end
