class CreateTypeOfExercises < ActiveRecord::Migration[7.1]
  def change
    create_table :type_of_exercises do |t|
      t.string :type

      t.timestamps
    end
  end
end
