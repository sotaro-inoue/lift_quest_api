class TypeOfExercise < ApplicationRecord
  has_many :exercises
  has_many :custom_type_of_exercises
  has_many :users, through: :custom_type_of_exercises

  # 優先度の定義
  enum priority: {
    normal: 0,     # 通常の種目
    important: 1,  # 重要な種目
    big3: 2        # BIG3
  }

  # BIG3の種目IDを定義
  BIG3_EXERCISES = {
    bench_press: 1,   # ベンチプレスのID
    squat: 2,         # スクワットのID
    deadlift: 3       # デッドリフトのID
  }

  enum difficulty_level: {
    beginner_friendly: 0,
    intermediate: 1,
    advanced: 2
  }

  enum main_target: {
    strength: 0,
    hypertrophy: 1,
    endurance: 2,
    compound: 3  # 複合的な効果
  }

  # ユーザーの経験レベルと目標に基づいて優先度を計算
  def calculate_priority_for_user(user)
    base_priority = self.priority || 0
    priority_score = base_priority

    # 経験レベルに基づく調整
    if user.beginner? && self.beginner_friendly?
      priority_score += 2
    elsif user.intermediate? && self.intermediate?
      priority_score += 1
    elsif user.advanced? && self.advanced?
      priority_score += 1
    end

    # トレーニング目標に基づく調整
    case user.training_goal
    when 'strength'
      priority_score += 2 if self.strength? || self.big3?
    when 'hypertrophy'
      priority_score += 2 if self.hypertrophy?
    when 'endurance'
      priority_score += 2 if self.endurance?
    when 'weight_loss'
      priority_score += 2 if self.compound?
    end

    priority_score
  end
end
