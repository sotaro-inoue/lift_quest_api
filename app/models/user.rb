# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  before_validation :ensure_user_id_has_at_mark
  
  private

  def ensure_user_id_has_at_mark
    if user_id.present? && !user_id.start_with?('@')
      self.user_id = "@#{user_id}"
    end
  end
end
