class CourseSubjectTask < ApplicationRecord
  belongs_to :course_subject

  has_many :user_tasks, dependent: :destroy
  has_many :user_course_subjects, through: :user_tasks

  validates :name, presence: true,
    length: {maximum: Settings.maximum_name_length}
  validates :description, presence: true,
    length: {maximum: Settings.maximum_content_length}
end
