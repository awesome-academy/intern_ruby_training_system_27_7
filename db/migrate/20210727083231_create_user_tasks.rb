class CreateUserTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :user_tasks do |t|
      t.references :user_course_subject, null: false, foreign_key: true
      t.references :course_subject_task, null: false, foreign_key: true
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
