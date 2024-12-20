class AddTrainingInfoToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :experience_level, :integer, default: 0
    add_column :users, :training_goal, :integer, default: 0
  end
end