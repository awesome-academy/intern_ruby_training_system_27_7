class UserCourseSubject < ApplicationRecord
  belongs_to :user_course
  belongs_to :course_subject

  has_many :user_tasks, dependent: :destroy
  has_many :course_subject_tasks, through: :user_tasks

  enum status: {start: 0, inprogress: 1, finished: 2, canceled: 3}
end
