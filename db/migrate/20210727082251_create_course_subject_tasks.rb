class CreateCourseSubjectTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :course_subject_tasks do |t|
      t.references :course_subject, null: false, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end

    add_index :course_subject_tasks, [:course_subject_id, :created_at]
  end
end
