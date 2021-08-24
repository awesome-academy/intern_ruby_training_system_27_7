require "rails_helper"
RSpec.describe UserCoursesController, type: :controller do
  let(:user1){FactoryBot.create :user}
  let(:user2){FactoryBot.create :user}
  let(:user3){FactoryBot.create :user, role_id: "admin"}
  let(:course){FactoryBot.create :course}
  let(:user_course_1){FactoryBot.create :user_course, course: course,
    user: user1}
  let(:user_course_2){FactoryBot.create :user_course, course: course,
    user: user2}
  let(:user_course_12){FactoryBot.create :user_course, course: course,
    user: user1, status: "finished"}
  let(:user_course_13){FactoryBot.create :user_course, course: course,
    user: user1, status: "start"}
  let(:subject_13){FactoryBot.create :subject}
  let(:course_subject_13){FactoryBot.create :course_subject, course: course,
    subject: subject_13}
  let(:user_course_subject_13){FactoryBot.create :user_course_subject,
    user_course: user_course_13, course_subject: course_subject_13,
    status: "start"}

  before{sign_in user1}

  describe "GET #index" do
    before{get :index}

    it "right amount of user course record" do
      expect(assigns[:user_courses].size).to eq user1.user_courses.size
    end

    it "render template index" do
      expect(response).to render_template :index
    end
  end

  describe "POST #create" do
    context "when user course information is valid" do
      before do
        sign_in user3
        post :create, params: {user_course: {course_id: course.id,
          user_id: [user1.id], user_ids: [user3.id]}}
      end

      it "flash success create user course success" do
        expect(flash[:success]).to eq I18n.t("user_courses.create.success")
      end

      it "redirect to courses page" do
        expect(response).to redirect_to courses_path
      end
    end

    context "when user course information is invalid" do
      before do
        sign_in user3
        post :create, params: {user_course: {course_id: nil,
          user_id: nil, user_ids:[nil]}}
      end

      it "flash danger create user course failed" do
        expect(flash[:danger]).to eq I18n.t("user_courses.create.failed")
      end

      it "redirect to courses page" do
        expect(response).to redirect_to courses_path
      end
    end

    context "when user course information is not unique" do
      let!(:course_1){FactoryBot.create :course}
      let!(:user_course_11){FactoryBot.create :user_course, course: course_1,
        user: user1}
      before do
        sign_in user3
        post :create, params: {user_course: {course_id: course_1.id,
          user_id: [user1.id], user_ids: [user1.id]}}
      end

      it "flash danger user had been in course" do
        expect(flash[:danger]).to eq I18n.t("user_courses.create.user_in_course")
      end

      it "redirect to courses page" do
        expect(response).to redirect_to courses_path
      end
    end
  end

  describe "GET #show" do
    context "when user course not exist" do
      before{get :show, params: {id: -1}}

      it "flash danger not found" do
        expect(flash[:danger]).to eq I18n.t("not found")
      end

      it "redirect to root path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when user course existed" do
      before{get :show, params: {id: user_course_1.id}}

      it "render show" do
        expect(response).to render_template :show
      end

      it "show correct user" do
        expect(assigns(:user_course)).to eq user_course_1
      end
    end
  end

  describe "PATCH #update" do
    context "when update successfully" do
      before do
        patch :update, params: {id: user_course_1.id, status: "canceled"}
      end

      it "flash success update user course" do
        expect(flash[:success]).to eq I18n.t("user_courses.update.success")
      end

      it "redirect to user course path" do
        expect(response).to redirect_to user_course_path
      end
    end

    context "when user course information is invalid" do
      before{patch :update, params: {id: user_course_1.id, status: "true"}}

      it "flash danger update user course fail" do
        expect(flash[:danger]).to eq I18n.t("user_courses.update.fail")
      end

      it "redirect to user course path" do
        expect(response).to redirect_to user_course_path
      end
    end

    context "when logged in wrong user" do
      before{patch :update, params: {id: user_course_2.id, status: "canceled"}}

      it "flash danger wrong user" do
        expect(flash[:danger]).to eq I18n.t("wrong_user")
      end

      it "redirect to user course path" do
        expect(response).to redirect_to user_course_path
      end
    end

    context "when user course not existed" do
      before{get :show, params: {id: -1}}

      it "flash danger not found" do
        expect(flash[:danger]).to eq I18n.t("not found")
      end

      it "redirect to root path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when user course hasn't started" do
      before do
        patch :update, params: {id: user_course_12.id, status: "canceled"}
      end

      it "flash danger course must start" do
        expect(flash[:danger]).to eq I18n.t("course_must_start")
      end

      it "redirect to user course path" do
        expect(response).to redirect_to user_course_path
      end
    end

    context "when user course subjects hasn't finished" do
      before do
        user_course_subject_13
        patch :update, params: {id: user_course_13.id, status: "finished"}
      end

      it "flash danger user course does not finish" do
        expect(flash[:info]).to eq I18n.t("user_courses.update.unfinish")
      end

      it "redirect to user course path" do
        expect(response).to redirect_to user_course_path
      end
    end
  end

  describe "DELETE #destroy" do
    context "when delete user course successfully" do
      before do
        sign_in user3
        delete :destroy, params: {id: user_course_1.id}
      end

      it "flash success message" do
        expect(flash[:success]).to eq I18n.t("user_course_deleted")
      end

      it "redirect to course path" do
        expect(response).to redirect_to course_path
      end
    end

    context "when delete user course failed" do
      let(:user_course_14) {double(:user_course, user: user1,
        course: course, id: 1000)}

      before do
        sign_in user3
        allow(user_course_14).to receive(:destroy).and_return(false)
        UserCourse.stub_chain(:includes, :find_by).and_return(user_course_14)
        delete :destroy, params: {id: user_course_14.id}
      end

      it "flash danger fail message" do
        expect(flash[:danger]).to eq I18n.t("delete_fail")
      end

      it "redirect to course path" do
        expect(response).to redirect_to course_path
      end
    end
  end
end
