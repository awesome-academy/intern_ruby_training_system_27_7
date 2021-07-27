class CreateUserCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :user_courses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :user_courses, [:user_id, :course_id], unique: true
  end
end
