class UserCourse < ApplicationRecord
  USER_COURSE_PARAMS = [:course_id, user_id: [], user_ids: []].freeze

  belongs_to :user
  belongs_to :course

  delegate :admin, :admin?, to: :user
  delegate :full_name, to: :user, prefix: true
  delegate :name, :description, :supervisor, :trainee, :users, :start_time,
           to: :course, prefix: true
  delegate :supervisor, :supervisor?, :trainee, :trainee?, to: :user

  has_many :user_course_subjects, dependent: :destroy
  has_many :course_subjects, through: :user_course_subjects

  accepts_nested_attributes_for :user_course_subjects, allow_destroy: true

  after_create :add_user_course_subjects, :create_notification
  after_update :create_notification

  enum status: {start: 0, inprogress: 1, finished: 2, canceled: 3}

  ransack_alias :name, :course_name_or_user_full_name

  ransacker :created_at, type: :date do
    Arel.sql("date(user_courses.created_at)")
  end

  def add_user_course_subjects
    return unless trainee?

    co_subs = course.course_subjects
    co_subs.each do |co_sub|
      user_course_subjects.create! course_subject_id: co_sub.id,
                                      start_time: Time.current
    end
  end

  def create_notification
    SendNotificationJob.perform_later self, course_name, "user_courses", user
  end
end
