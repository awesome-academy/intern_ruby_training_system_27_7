class UserReport < ApplicationRecord
  USER_REPORT_PARAMS = %i(user_id course_id content date).freeze

  belongs_to :user
  belongs_to :course

  delegate :name, to: :course, prefix: true
  delegate :full_name, to: :user, prefix: true

  validates :content, presence: true,
    length: {maximum: Settings.maximum_content_length}
  validates :date, presence: true

  scope :recent, ->{order(date: :desc)}
end
