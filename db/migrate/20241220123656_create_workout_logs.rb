class CreateWorkoutLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :workout_logs do |t|
      t.text :notes
      t.integer :user_id

      t.timestamps
    end
  end
end
