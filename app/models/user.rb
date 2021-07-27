class User < ApplicationRecord
  has_many :user_courses, dependent: :destroy
  has_many :courses, through: :user_courses
  has_many :user_reports, dependent: :destroy

  validates :full_name, presence: true,
    length: {maximum: Settings.maximum_name_length}
  validates :email, presence: true,
    length: {maximum: Settings.maximum_email_length},
    format: {with: Settings.valid_email_regex}, uniqueness: true
  validates :password, presence: true,
    length: {minimum: Settings.minimum_password_length}, allow_nil: true

  before_save :downcase_email

  enum role_id: {admin: 0, supervisor: 1, trainee: 2}

  private
  def downcase_email
    email.downcase!
  end
end
