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
  validates :user_id,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: /\A@[a-zA-Z0-9_]+\z/, message: "は@で始まる半角英数字とアンダースコアのみ使用できます" },
    length: { minimum: 2, maximum: 21 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password, length: { minimum: 6 }, allow_blank: true, on: :update

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

  # 認証時のユーザー検索メソッド
  def self.find_for_authentication(auth_conditions)
    Rails.logger.debug "Auth conditions: #{auth_conditions.inspect}"
    if auth_conditions[:identifier].present?
      identifier = auth_conditions[:identifier]
      if identifier.start_with?("@")
        find_by(user_id: identifier)
      else
        find_by(email: identifier)
      end
    else
      super
    end
  end

  def build_auth_header(token, client)
    {
      "access-token" => token,
      "client" => client,
      "expiry" => (Time.now + 2.weeks).to_i.to_s,
      "uid" => email
    }
  end

  private

  def log_errors
    Rails.logger.debug "User validation errors: #{errors.full_messages}"
  end
end
