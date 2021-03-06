class UserReport < ApplicationRecord
  USER_REPORT_PARAMS = %i(user_id course_id content date).freeze
  SORT_PARAMS = ["date desc", "course_name asc", "content asc"].freeze

  belongs_to :user
  belongs_to :course

  delegate :name, to: :course, prefix: true
  delegate :full_name, to: :user, prefix: true

  validates :content, presence: true,
    length: {maximum: Settings.maximum_content_length}
  validates :date, presence: true

  scope :recent, ->{order(date: :desc)}
  scope :search_by_date, ->(date){where(date: date) if date.present?}
  scope :search_by_course_id, (lambda do |course_id|
    where(course_id: course_id) if course_id.present?
  end)
  scope :search_by_content, ->(text){where("content LIKE ?", "%#{text}%")}

  ransack_alias :contain, :content_or_course_name

  ransacker :created_at, type: :date do
    Arel.sql("date(user_reports.created_at)")
  end

  class << self
    def search params
      search_by_date(params[:date]).search_by_course_id(params[:course_id])
                                   .search_by_content(params[:content])
    end
  end
end
