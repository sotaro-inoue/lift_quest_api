class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table(:users) do |t|
      ## Required
      t.string :provider, null: false, default: "email"
      t.string :uid, null: false, default: ""

      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ""

      ## User Info
      t.string :name, null: false
      t.string :user_id, null: false
      t.string :email, null: false

      ## Tokens
      t.text :tokens

      t.timestamps

      t.index :email, unique: true
      t.index :user_id, unique: true
      t.index [ :uid, :provider ], unique: true
    end
  end
end
