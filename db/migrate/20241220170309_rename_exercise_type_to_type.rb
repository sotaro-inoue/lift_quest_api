class RenameExerciseTypeToType < ActiveRecord::Migration[7.1]
  def change
    rename_column :type_of_exercises, :exercise_type, :type_of_exercise
  end
end