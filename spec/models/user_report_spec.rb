require "rails_helper"

RSpec.describe UserReport, type: :model do
  let(:user){FactoryBot.create :user}
  let(:course){FactoryBot.create :course}
  let!(:report_1){FactoryBot.create :user_report, content: "The first report",
                   date: 2.days.ago, course: course, user: user}
  let!(:report_2){FactoryBot.create :user_report, content: "The second report",
                   date: 1.day.ago, course: course, user: user}
  let!(:report_3){FactoryBot.create :user_report, content: "The third report",
                   date: Time.now, course: course, user: user}

  describe ".recent" do
    it {expect(UserReport.recent).to eq([report_3, report_2, report_1])}
  end

  describe ".search_by_date" do
    it {expect(UserReport.search_by_date(1.day.ago)).to eq([report_2])}
  end

  describe ".search_by_course_id" do
    it {expect(UserReport.search_by_course_id(course.id).pluck(:id))
          .to eq([report_1.id, report_2.id, report_3.id])}
  end

  describe ".search_by_content" do
    it {expect(UserReport.search_by_content("third")).to eq([report_3])}
  end

  describe ".search" do
    it "search by params" do
      params = {date: Time.now, course_id: course.id, content: "report"}
      expect(UserReport.search params).to eq([report_3])
    end
  end
end
