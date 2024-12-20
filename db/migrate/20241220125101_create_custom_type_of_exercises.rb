class CreateCustomTypeOfExercises < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_type_of_exercises do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true
      t.references :type_of_exercise, foreign_key: true
      t.timestamps
    end

    add_index :custom_type_of_exercises, [:user_id, :name], unique: true
  end
end 