class CreateWorkoutLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_logs do |t|
      t.string :exercise_name
      t.string :type_of_exercise
      t.float :weight
      t.integer :reps

      t.timestamps
    end
  end
end
