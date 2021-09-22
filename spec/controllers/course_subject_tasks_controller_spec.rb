require "rails_helper"

RSpec.describe CourseSubjectTasksController, type: :controller do
  let(:user){FactoryBot.create :user, role_id: "supervisor"}
  let(:user2){FactoryBot.create :user2, role_id: "trainee"}
  let(:course){FactoryBot.create :course}
  let(:subject){FactoryBot.create :subject}
  let!(:course_subject){FactoryBot.create :course_subject, course: course,
                        subject: subject}
  let(:course_subject_task){FactoryBot.create :course_subject_task,
                              course_subject: course_subject}


  before{sign_in user}

  describe "DELETE /destroy" do
    context "when not found task to destroy" do
      it_behaves_like "not found to destroy", :course
    end

    context "when destroy course_subject_task success" do
      before do
        delete :destroy, params: {id: course_subject_task.id}
      end

      it_behaves_like "destroy object success", :course
    end

    context "when destroy course_subject_task failed" do
      before do
        allow_any_instance_of(CourseSubjectTask).to receive(:destroy)
          .and_return(false)

        delete :destroy, params: {id: course_subject_task.id}
      end

      it_behaves_like "destroy object failed", :course
    end
  end
end
