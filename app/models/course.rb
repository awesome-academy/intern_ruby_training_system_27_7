class Course < ApplicationRecord
  COURSE_PARAMS = [:name, :description, :start_time,
    subject_ids: [],
    course_subjects_attributes: [:id, :course_id, :subject_id],
    user_ids: [],
    user_courses_attributes: [:id, :user_id, :course_id]].freeze

  COURSE_INCLUDES = [:subjects, :users, course_subjects:
    [{course_subject_tasks: :user_tasks},
    {user_course_subjects: :user_tasks}], user_courses:
    {user_course_subjects: :user_tasks}].freeze

  delegate :admin, :supervisor, :trainee, to: :users

  has_many :course_subjects, dependent: :destroy
  has_many :subjects, through: :course_subjects
  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :user_reports, dependent: :destroy

  accepts_nested_attributes_for :course_subjects, allow_destroy: true
  accepts_nested_attributes_for :user_courses, allow_destroy: true

  validates :name, presence: true,
    length: {maximum: Settings.maximum_name_length}, uniqueness: true
  validates :description, presence: true,
    length: {maximum: Settings.maximum_content_length}
  validates :start_time, presence: true

  enum status: {start: 0, inprogress: 1, finished: 2, canceled: 3}
end
