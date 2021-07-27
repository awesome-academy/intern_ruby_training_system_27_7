class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :full_name
      t.integer :role_id, null: false, default: 2

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
