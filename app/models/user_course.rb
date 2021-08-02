class UserCourse < ApplicationRecord
  USER_COURSE_PARAMS = [:course_id, user_id: [], user_ids: []].freeze

  belongs_to :user
  belongs_to :course

  delegate :admin, :admin?, to: :user
  delegate :full_name, to: :user, prefix: true
  delegate :name, to: :course, prefix: true
  delegate :start_time, to: :course
  delegate :supervisor, :supervisor?, :trainee, :trainee?, to: :user

  has_many :user_course_subjects, dependent: :destroy
  has_many :course_subjects, through: :user_course_subjects

  accepts_nested_attributes_for :user_course_subjects, allow_destroy: true

  enum status: {start: 0, inprogress: 1, finished: 2, canceled: 3}
end
