class UserCourseSubject < ApplicationRecord
  USER_COURSE_SUBJECT_PARAMS = :status

  belongs_to :user_course
  belongs_to :course_subject

  delegate :subject_name, :current_duration, to: :course_subject, prefix: true
  delegate :course_name, to: :user_course, prefix: true

  validates :status, presence: true

  has_many :user_tasks, dependent: :destroy
  has_many :course_subject_tasks, through: :user_tasks

  after_create :add_user_tasks
  after_update :start_next_subject, :cancel_course, :create_notification

  scope :order_by, (lambda do |column, order_type|
    order("#{column} #{order_type}")
  end)
  scope :get_course_id, ->(sub_id){select(:user_course_id).where(id: sub_id)}
  scope :same_course, (lambda do |sub_id|
    where(user_course_id: UserCourseSubject.get_course_id(sub_id))
  end)
  scope :prev_subject, (lambda do |cur_id|
    same_course(cur_id).where("id < ?", cur_id).order_by(:id, :desc).first
  end)
  scope :next_subject, (lambda do |cur_id|
    same_course(cur_id).where("id > ?", cur_id).order_by(:id, :asc).first
  end)
  scope :not_status, ->(status){where.not(status: status)}

  enum status: {start: 0, inprogress: 1, finished: 2, canceled: 3}

  def pre_sub_finished?
    return true if id == user_course.user_course_subjects.first.id

    prev_sub = UserCourseSubject.prev_subject id
    prev_sub.finished?
  end

  def current_start_time
    return start_time if start_time

    first_id = user_course.user_course_subjects.first.id
    return user_course.course.start_time if id == first_id

    prev_sub = UserCourseSubject.prev_subject id
    prev_sub.user_course.course.start_time + prev_sub.course_subject
                                                     .current_duration.day
  end

  def get_next_subject
    last_id = user_course.user_course_subjects.last.id
    return if id == last_id

    UserCourseSubject.next_subject id
  end

  def get_prev_subject
    first_id = user_course.user_course_subjects.first.id
    return if id == first_id

    UserCourseSubject.prev_subject id
  end

  def first_subject?
    first_id = user_course.user_course_subjects.first.id
    id == first_id
  end

  def end_time
    current_start_time + course_subject.current_duration.day
  end

  def add_user_tasks
    course_subject.course_subject_tasks.each do |task|
      user_tasks.create! course_subject_task_id: task.id
    end
  end

  def start_next_subject
    return unless finished?

    next_subject = get_next_subject
    next_subject&.update status: "inprogress", start_time: Time.current
  end

  def cancel_course
    return unless canceled?

    user_course.update status: "canceled"
  end

  def create_notification
    header = user_course_course_name + "/" + course_subject_subject_name
    SendNotificationJob.perform_later self, header, "user_course_subjects",
                                      user_course.user
  end
end
