class WorkoutLog < ApplicationRecord
  belongs_to :user
  has_many :exercises, dependent: :destroy
  has_many :type_of_exercises, through: :exercises
  
  validates :notes, length: { maximum: 500 }
  validates :user_id, presence: true
end
