class Ability
  include CanCan::Ability

  def initialize user
    return if user.blank?

    can :manage, UserReport, user_id: user.id
    can :read, [Course, CourseSubject]
    return unless user.supervisor? || user.admin?

    can :read, UserReport
    can :manage, [Course, CourseSubject, CourseSubjectTask]
  end
end
