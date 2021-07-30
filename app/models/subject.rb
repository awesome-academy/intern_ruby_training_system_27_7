class Subject < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :course_subjects, dependent: :destroy
  has_many :courses, through: :course_subjects

  validates :name, presence: true,
    length: {maximum: Settings.maximum_name_length}, uniqueness: true
  validates :description, presence: true,
    length: {maximum: Settings.maximum_content_length}
  validates :duration, presence: true

  scope :get_list, ->{select(:id, :name)}
end
