require "rails_helper"

RSpec.describe UserReportsController, type: :controller do
  let(:user){FactoryBot.create :user}
  let(:user2){FactoryBot.create :user, full_name: "Name 2", email: "test2@mail.com"}
  let(:user3){FactoryBot.create :user, full_name: "Name 3", email: "test3@mail.com"}
  let(:course){FactoryBot.create :course}
  let!(:user_course){FactoryBot.create :user_course, course: course, user: user}
  let!(:user_course2){FactoryBot.create :user_course,
                        course: course, user: user2}
  let(:report_1){FactoryBot.create :user_report, content: "The first report",
                   date: 2.days.ago, course: course, user: user}
  let(:report_2){FactoryBot.create :user_report, content: "The first report",
                   date: 2.days.ago, course: course, user: user2}
  let(:report_4){FactoryBot.create :user_report, content: "The second report",
                   date: 1.days.ago, course: course, user: user}

  before{sign_in user}

  describe "GET /index" do
    context "when user has courses" do
      before{get :index}

      it "render template index" do
        expect(response).to render_template :index
      end
    end

    context "when user don't have course" do
      before do
        sign_in user3
        get :index
      end

      it "redirect to root url" do
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "GET /index with search" do
    context "when user search course and result not empty" do
      before do
        get :index, params: {q: {content_cont: "",
          course_name_start: course.name,
          date_gteq: 3.days.ago, date_lteq: 1.days.ago, contain_cont: ""}}
      end

      it "will return result with order" do
        expect(assigns(:user_reports)).to eq([report_4, report_1])
      end
    end

    context "when user search course and result empty" do
      before do
        get :index, params: {q: {content_cont: "",
          course_name_start: "",
          date_gteq: 3.days.ago, date_lteq: 3.days.ago, contain_cont: ""}}
      end

      it "will return empty array" do
        expect(assigns(:user_reports)).to be_empty
      end
    end
  end

  describe "GET /new" do
    before{get :new}

    it "render template new" do
      expect(response).to render_template :new
    end

    it "assign new object for UserReport" do
      expect(assigns(:user_report)).to be_a_new UserReport
    end
  end

  describe "POST /create" do
    context "when user report informatuon is valid" do
      before do
        post :create, params: {user_report: {course_id: course.id,
          date: Time.now, content: "Content"}}
      end

      it "flash success information" do
        expect(flash[:success]).to eq I18n.t("success")
      end

      it "redirect to list report page" do
        expect(response).to redirect_to user_reports_path
      end
    end

    context "when user report information is invalid" do
      before do
        post :create, params: {user_report: {course_id: course.id,
          date: Time.now, content: ""}}
      end

      it "render template new" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET /show" do
    context "when report not exist" do
      before{get :show, params: {id: -1}}

      it "flash danger report not found" do
        expect(flash[:danger]).to eq I18n.t("report_not_found")
      end

      it "redirect to list report page" do
        expect(response).to redirect_to user_reports_path
      end
    end

    context "when report existed but not owned by current_user" do
      before{get :show, params: {id: report_2.id}}

      it "will flash alert report when you don't have authorized" do
        expect(flash[:alert]).to be_present
      end

      it "redirect to list report page" do
        expect(response).to redirect_to root_path
      end
    end

    context "when report existed and owned by current_user" do
      before{get :show, params: {id: report_1.id}}

      it "render template show" do
        expect(response).to render_template :show
      end

      it "assign report_1 to variable @user_report" do
        expect(assigns(:user_report)).to eq report_1
      end
    end
  end

  describe "GET /edit" do
    context "when report not exist" do
      before{get :edit, params: {id: -1}}

      it "flash danger report not found" do
        expect(flash[:danger]).to eq I18n.t("report_not_found")
      end

      it "redirect to list report page" do
        expect(response).to redirect_to user_reports_path
      end
    end

    context "when report existed but not owned by current_user" do
      before{get :edit, params: {id: report_2.id}}

      it "will flash alert report when you don't have authorized" do
        expect(flash[:alert]).to be_present
      end

      it "redirect to list report page" do
        expect(response).to redirect_to root_path
      end
    end

    context "when report existed and owned by current_user" do
      before{get :edit, params: {id: report_1.id}}

      it "render template edit" do
        expect(response).to render_template :edit
      end

      it "assign report_1 to variable @user_report" do
        expect(assigns(:user_report)).to eq report_1
      end
    end
  end

  describe "PATCH /update" do
    context "when update successfully" do
      before do
        patch :update, params: {id: report_1.id,
          user_report: {course_id: report_1.course_id,
            user_id: report_1.user_id, content: "New content"}}
      end

      it "flash update successfully" do
        expect(flash[:success])
          .to eq I18n.t("user_reports.update.updated_success")
      end

      it "redirect to list report page" do
        expect(response).to redirect_to user_reports_path
      end
    end

    context "when update failed" do
      before do
        patch :update, params: {id: report_1.id,
          user_report: {course_id: report_1.course_id,
            user_id: report_1.user_id, content: ""}}
      end

      it "flash update fail" do
        expect(flash[:danger])
          .to eq I18n.t("user_reports.update.updated_fail")
      end

      it "render template edit" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE /destroy" do
    context "delete report successfully" do
      before{delete :destroy, params: {id: report_1.id}}

      it "flash delete successfully" do
        expect(flash[:success]).to eq I18n.t("user_report_deleted")
      end

      it "redirect to list report page" do
        expect(response).to redirect_to user_reports_path
      end
    end

    context "delete report failed" do
      before do
        allow_any_instance_of(UserReport).to receive(:destroy).and_return(false)

        delete :destroy, params: {id: report_1.id}
      end

      it "flash danger delete fail" do
        expect(flash[:danger]).to eq I18n.t("delete_fail")
      end

      it "redirect to list report page" do
        expect(response).to redirect_to user_reports_path
      end
    end
  end
end
