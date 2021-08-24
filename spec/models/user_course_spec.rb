require "rails_helper"

RSpec.describe UserCourse, type: :model do
  let(:user1){FactoryBot.create :user}
  let(:subject_1){FactoryBot.create :subject}
  let!(:course){FactoryBot.create :course}
  let!(:course_subject_1){FactoryBot.create :course_subject, course: course,
    subject: subject_1}
  let!(:user_course_1){FactoryBot.create :user_course, course: course,
    user: user1}

  describe ".add_user_course_subjects" do
    it "add user course subject" do
      expect(user_course_1.add_user_course_subjects).to eq([course_subject_1])
    end
  end
end
