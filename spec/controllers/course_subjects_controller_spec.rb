require "rails_helper"

RSpec.describe CourseSubjectsController, type: :controller do
  let(:user){FactoryBot.create :user, role_id: "supervisor"}
  let(:user2){FactoryBot.create :user2, role_id: "trainee"}
  let(:course){FactoryBot.create :course}
  let(:subject){FactoryBot.create :subject}
  let(:course_subject){FactoryBot.create :course_subject, course: course,
                        subject: subject}

  before{sign_in user}

  describe "GET /show" do
    context "when course subject not exist" do
      before{get :show, params: {id: -1}}

      it "flash danger course_subject not found" do
        expect(flash[:danger]).to be_present
      end

      it "redirect to root page" do
        expect(response).to redirect_to root_path
      end
    end

    context "when course_subject existed" do
      before{get :show, params: {id: course_subject.id}}

      it "will render template show" do
        expect(response).to render_template :show
      end

      it "will assign course to variable @course" do
        expect(assigns(:course)).to eq course
      end
    end
  end

  describe "DELETE /destroy" do
    context "when not found course_subject to destroy" do
      before do
        delete :destroy, params: {id: -1}
      end

      it "will redirect to root page" do
        expect(response).to redirect_to root_path
      end

      it "will have flash danger present" do
        expect(flash[:danger]).to be_present
      end
    end

    context "when destroy course_subject success" do
      before do
        delete :destroy, params: {id: course_subject.id}
      end

      it_behaves_like "destroy object success", :course
    end

    context "when destroy course_subject_task failed" do
      before do
        allow_any_instance_of(CourseSubject).to receive(:destroy)
          .and_return(false)

        delete :destroy, params: {id: course_subject.id}
      end

      it_behaves_like "destroy object failed", :course
    end
  end
end
