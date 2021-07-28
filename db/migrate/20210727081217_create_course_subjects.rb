class CreateCourseSubjects < ActiveRecord::Migration[6.1]
  def change
    create_table :course_subjects do |t|
      t.references :course, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.time :duration

      t.timestamps
    end

    add_index :course_subjects, [:course_id, :subject_id], unique: true
  end
end
