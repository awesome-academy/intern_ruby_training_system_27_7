class UserReport < ApplicationRecord
  belongs_to :user
  belongs_to :course

  validates :content, presence: true,
    length: {maximum: Settings.maximum_content_length}
  validates :date, presence: true
end
