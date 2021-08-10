class CourseSubject < ApplicationRecord
  COURSE_SUBJECTS_PARAMS = [:course_id, subject_id: [], subject_ids: []].freeze

  belongs_to :course
  belongs_to :subject

  delegate :name, to: :subject, prefix: true

  has_many :course_subject_tasks, dependent: :destroy
  has_many :user_course_subjects, dependent: :destroy
  has_many :user_courses, through: :user_course_subjects

  after_create :add_course_subject_tasks, :update_user_course

  scope :order_create, ->{order(created_at: :asc)}

  def current_duration
    return duration unless duration.nil?

    subject.duration
  end

  private
  def add_course_subject_tasks
    subject.tasks.each do |task|
      course_subject_tasks.create! name: task.name,
                                   description: task.description
    end
  end

  def update_user_course
    course.user_courses.each do |user_course|
      next unless user_course.trainee?

      next if user_course.new_record?

      next if user_course.user_course_subjects
                         .find_by course_subject_id: subject.id

      user_course.user_course_subjects.create! course_subject_id: id
    end
  end
end
