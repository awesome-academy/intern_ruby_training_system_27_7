class UserTask < ApplicationRecord
  belongs_to :user_course_subject
  belongs_to :course_subject_task

  enum status: {start: 0, inprogress: 1, finished: 2, canceled: 3}
end
