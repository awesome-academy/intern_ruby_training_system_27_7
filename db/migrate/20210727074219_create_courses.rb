class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.string :name
      t.text :description
      t.date :start_time
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :courses, :name, unique: true
  end
end
