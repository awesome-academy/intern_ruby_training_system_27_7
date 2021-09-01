require "rails_helper"

RSpec.describe CoursesController, type: :controller do
  let(:user){FactoryBot.create :user, role_id: "supervisor"}
  let(:user2){FactoryBot.create :user, full_name: "Name 2", email: "test2@mail.com"}
  let(:course){FactoryBot.create :course}
  let(:course_1){FactoryBot.create :course, start_time: 2.days.ago}


  before{sign_in user}

  describe "GET /index" do
    context "when supervisor has been login" do
      before{get :index}

      it "render template index" do
        expect(response).to render_template :index
      end
    end
  end

  describe "GET /index with search" do
    context "when search course and result not empty" do
      before do
        get :index, params: {q: {date_gteq: 3.days.ago, date_lteq: 1.days.ago}}
      end

      it "will return result with order" do
        expect(assigns(:courses)).to eq([course_1])
      end
    end

    context "when search course and result empty" do
      before do
        get :index, params: {q: {date_gteq: 3.days.ago, date_lteq: 3.days.ago}}
      end

      it "will return empty array" do
        expect(assigns(:courses)).to be_empty
      end
    end
  end

  describe "GET /new" do
    before{get :new}

    it "render template new" do
      expect(response).to render_template :new
    end

    it "assign new object for Course" do
      expect(assigns(:course)).to be_a_new Course
    end
  end

  describe "POST /create" do
    context "when course information is valid" do
      before do
        post :create, params: {course: {name: "Name", description: "Content", start_time: Time.now}}
      end

      it "will flash success information" do
        expect(flash[:success]).to be_present
      end

      it "redirect to list courses page" do
        expect(response).to redirect_to courses_path
      end
    end

    context "when course information is invalid" do
      before do
        post :create, params: {course: {name: "Name", description: ""}}
      end

      it "will render template new" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET /show" do
    context "when course not exist" do
      before{get :show, params: {id: -1}}

      it "flash danger report not found" do
        expect(flash[:danger]).to be_present
      end

      it "redirect to root page" do
        expect(response).to redirect_to root_path
      end
    end

    context "when course existed" do
      before{get :show, params: {id: course.id}}

      it "will render template show" do
        expect(response).to render_template :show
      end

      it "will assign course to variable @course" do
        expect(assigns(:course)).to eq course
      end
    end
  end

  describe "DELETE /destroy" do
    context "delete course successfully" do
      before{delete :destroy, params: {id: course.id}}

      it "flash delete successfully" do
        expect(flash[:success]).to be_present
      end

      it "redirect to courses index" do
        expect(response).to redirect_to courses_path
      end
    end

    context "delete course failed" do
      before do
        allow_any_instance_of(Course).to receive(:destroy).and_return(false)

        delete :destroy, params: {id: course.id}
      end

      it "flash danger delete fail" do
        expect(flash[:danger]).to be_present
      end

      it "redirect to index course page" do
        expect(response).to redirect_to courses_path
      end
    end
  end
end
