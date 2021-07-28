class Course < ApplicationRecord
  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :user_reports, dependent: :destroy
  has_many :course_subjects, dependent: :destroy
  has_many :subjects, through: :course_subjects

  validates :name, presence: true,
    length: {maximum: Settings.maximum_name_length}, uniqueness: true
  validates :description, presence: true,
    length: {maximum: Settings.maximum_content_length}

  enum status: {start: 0, inprogress: 1, finished: 2, canceled: 3}
end
