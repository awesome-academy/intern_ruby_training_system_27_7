class CourseSubject < ApplicationRecord
  COURSE_SUBJECTS_PARAMS = [:course_id, subject_id: [], subject_ids: []].freeze

  belongs_to :course
  belongs_to :subject

  delegate :name, to: :subject, prefix: true

  has_many :course_subject_tasks, dependent: :destroy
  has_many :user_course_subjects, dependent: :destroy
  has_many :user_courses, through: :user_course_subjects

  after_create :update_user_course

  def current_duration
    return duration unless duration.nil?

    subject.duration
  end

  private
  def update_user_course
    course.user_courses.each do |user_course|
      next if user_course.user_course_subjects
                         .find_by course_subject_id: subject.id

      user_subject = user_course.user_course_subjects
                                .build course_subject_id: subject.id
      user_subject.save!
    end
  end
end
