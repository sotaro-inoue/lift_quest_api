class CustomTypeOfExercise < ApplicationRecord
  belongs_to :user
  belongs_to :type_of_exercise, optional: true
  has_many :exercises
  
  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }
end 