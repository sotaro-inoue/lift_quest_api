# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

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

  private

  def log_errors
    Rails.logger.debug "User validation errors: #{errors.full_messages}"
  end
end
