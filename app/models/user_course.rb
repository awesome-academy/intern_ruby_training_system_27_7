class UserCourse < ApplicationRecord
  belongs_to :user
  belongs_to :course

  has_many :user_course_subjects, dependent: :destroy
  has_many :course_subjects, through: :user_course_subjects

  enum status: {start: 0, inprogress: 1, finished: 2, canceled: 3}
end
