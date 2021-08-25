require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  let(:user){FactoryBot.create :user}

  before{@request.env["devise.mapping"] = Devise.mappings[:user]}

  describe "GET /new" do
    before {get :new}

    it "render template new" do
      expect(response).to render_template :new
    end
  end

  describe "POST /create" do
    context "when login with correct information" do
      before do
        post :create, params: {user: {email: user.email, password: user.password}}
      end

      it "will redirect to root page" do
        expect(response).to redirect_to root_path
      end

      it "will have flash success" do
        expect(flash[:notice]).to be_present
      end
    end

    context "when login with wrong information" do
      before do
        post :create, params: {user: {email: user.email, password: ""}}
      end

      it "will render template new again" do
        expect(response).to render_template :new
      end

      it "will have flash success" do
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "DELETE /destroy" do
    context "when user login" do
      before do
        sign_in user
        delete :destroy
      end

      it "will redirect to root page" do
        expect(response).to redirect_to root_path
      end

      it "will have flash success logout" do
        expect(flash[:notice]).to eq I18n.t("devise.sessions.signed_out")
      end
    end

    context "when user not login" do
      before do
        delete :destroy
      end

      it "will redirect to root page" do
        expect(response).to redirect_to root_path
      end

      it "will have flash have been logout" do
        expect(flash[:notice]).to eq I18n.t("devise.sessions.already_signed_out")
      end
    end
  end
end
