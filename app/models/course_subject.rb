class CourseSubject < ApplicationRecord
  belongs_to :course
  belongs_to :subject

  has_many :course_subject_tasks, dependent: :destroy
  has_many :user_course_subjects, dependent: :destroy
  has_many :user_courses, through: :user_course_subjects

  validates :duration, presence: true
end
