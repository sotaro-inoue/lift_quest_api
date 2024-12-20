class AddCharacteristicsToTypeOfExercises < ActiveRecord::Migration[7.1]
  def change
    add_column :type_of_exercises, :difficulty_level, :integer, default: 0
    add_column :type_of_exercises, :main_target, :integer, default: 0
  end
end