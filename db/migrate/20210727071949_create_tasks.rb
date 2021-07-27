class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.references :subject, null: false, foreign_key: true

      t.timestamps
    end

    add_index :tasks, [:subject_id, :created_at]
  end
end
