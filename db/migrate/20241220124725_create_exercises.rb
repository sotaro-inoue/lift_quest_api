class CreateExercises < ActiveRecord::Migration[7.1]
  def change
    create_table :exercises do |t|
      t.integer :workout_log_id
      t.integer :type_of_exercise_id
      t.string :exercise_name
      t.float :weight
      t.integer :reps
      t.integer :sets

      t.timestamps
    end
  end
end
