# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :workout_logs, dependent: :destroy
  has_many :exercises, through: :workout_logs
  has_many :custom_type_of_exercises
  has_many :type_of_exercises, through: :custom_type_of_exercises

  validates :name, presence: true
  validates :user_id, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: {
                      with: /\A@[a-zA-Z0-9_]+\z/,
                      message: "は@で始まる半角英数字とアンダースコアのみ使用できます"
                    },
                    length: { minimum: 3, maximum: 21 }

  # デバッグ用のコールバック
  after_validation :log_errors, if: -> { errors.any? }

  enum experience_level: {
    beginner: 0,      # 初心者
    intermediate: 1,  # 中級者
    advanced: 2       # 上級者
  }

  enum training_goal: {
    strength: 0,     # 筋力アップ
    hypertrophy: 1,  # 筋肥大
    endurance: 2,    # 持久力
    weight_loss: 3,  # 減量
    general: 4       # 総合的な体力向上
  }

  private

  def log_errors
    Rails.logger.debug "User validation errors: #{errors.full_messages}"
  end
end
