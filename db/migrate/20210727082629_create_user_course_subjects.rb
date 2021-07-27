class CreateUserCourseSubjects < ActiveRecord::Migration[6.1]
  def change
    create_table :user_course_subjects do |t|
      t.references :user_course, null: false, foreign_key: true
      t.references :course_subject, null: false, foreign_key: true
      t.date :start_time
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
