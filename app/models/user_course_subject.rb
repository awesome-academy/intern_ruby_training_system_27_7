class UserCourseSubject < ApplicationRecord
  belongs_to :user_course
  belongs_to :course_subject

  has_many :user_tasks, dependent: :destroy
  has_many :course_subject_tasks, through: :user_tasks

  after_create :add_user_tasks

  enum status: {start: 0, inprogress: 1, finished: 2, canceled: 3}

  private
  def add_user_tasks
    course_subject.course_subject_tasks.each do |task|
      user_tasks.create! course_subject_task_id: task.id
    end
  end
end
