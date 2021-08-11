class CourseSubjectTask < ApplicationRecord
  COURSE_SUBJECT_TASKS_PARAMS = %i(course_subject_id name description).freeze

  belongs_to :course_subject

  has_many :user_tasks, dependent: :destroy
  has_many :user_course_subjects, through: :user_tasks

  validates :name, presence: true,
    length: {maximum: Settings.maximum_name_length}
  validates :description, presence: true,
    length: {maximum: Settings.maximum_content_length}

  after_create :update_user_tasks

  private
  def update_user_tasks
    course_subject.user_course_subjects.each do |user_course_subject|
      next if user_course_subject.user_tasks.find_by course_subject_task_id: id

      user_course_subject.user_tasks.create! course_subject_task_id: id
    end
  end
end
