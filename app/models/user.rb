class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  TRAINEE_PARAMS = %i(email full_name password password_confirmation).freeze
  USER_PARAMS = %i(email full_name password password_confirmation).freeze
  USER_INCLUDES = [user_courses: {user_course_subjects: :user_tasks}].freeze

  has_many :user_courses, dependent: :destroy
  has_many :courses, through: :user_courses
  has_many :user_reports, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :full_name, presence: true,
    length: {maximum: Settings.maximum_name_length}
  validates :email, presence: true,
    length: {maximum: Settings.maximum_email_length},
    format: {with: Settings.valid_email_regex}, uniqueness: true
  validates :password, presence: true,
    length: {minimum: Settings.minimum_password_length}, allow_nil: true

  before_save :downcase_email

  scope :get_name, ->{select(:id, :full_name)}

  enum role_id: {admin: 0, supervisor: 1, trainee: 2}

  class << self
    def digest string
      min_cost = ActiveModel::SecurePassword.min_cost
      cost = min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end
  end

  def send_delete_account_email
    UserMailer.delete_account(email).deliver_later
  end

  def send_devise_notification notification, *args
    devise_mailer.send(notification, self, *args).deliver_later
  end

  private
  def downcase_email
    email.downcase!
  end
end
