class AddColumsToWorkoutLog < ActiveRecord::Migration[7.1]
  def change
    add_column :workout_logs, :sets, :integer, after: :reps
  end
end
