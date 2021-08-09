class UserCourseSubject < ApplicationRecord
  belongs_to :user_course
  belongs_to :course_subject

  delegate :subject_name, :current_duration, to: :course_subject, prefix: true

  has_many :user_tasks, dependent: :destroy
  has_many :course_subject_tasks, through: :user_tasks

  after_create :add_user_tasks

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

  def end_time
    current_start_time + course_subject.current_duration.day
  end

  def add_user_tasks
    course_subject.course_subject_tasks.each do |task|
      user_tasks.create! course_subject_task_id: task.id
    end
  end
end
