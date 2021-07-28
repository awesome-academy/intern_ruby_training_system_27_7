class Task < ApplicationRecord
  belongs_to :subject

  validates :name, presence: true,
    length: {maximum: Settings.maximum_name_length}
  validates :description, presence: true,
    length: {maximum: Settings.maximum_content_length}
end
