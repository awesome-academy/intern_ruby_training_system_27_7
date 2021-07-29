class Course < ApplicationRecord
  COURSE_PARAMS = [:name, :description, :start_time,
    subject_ids: [],
    course_subjects_attributes: [:id, :course_id, :subject_id]].freeze

  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :user_reports, dependent: :destroy
  has_many :course_subjects, dependent: :destroy
  has_many :subjects, through: :course_subjects

  accepts_nested_attributes_for :course_subjects, allow_destroy: true

  validates :name, presence: true,
    length: {maximum: Settings.maximum_name_length}, uniqueness: true
  validates :description, presence: true,
    length: {maximum: Settings.maximum_content_length}

  enum status: {start: 0, inprogress: 1, finished: 2, canceled: 3}
end
