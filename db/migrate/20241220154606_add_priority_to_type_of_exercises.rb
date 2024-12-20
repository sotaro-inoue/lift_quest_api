class AddPriorityToTypeOfExercises < ActiveRecord::Migration[7.1]
  def change
    add_column :type_of_exercises, :priority, :integer, default: 0, after: :type
  end
end
