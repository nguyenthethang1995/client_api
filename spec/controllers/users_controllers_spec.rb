require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :controller do
  before { create_list(:user, 10) }

  describe "#index" do
    before { get :index }

    context "when users exit" do
      it "return all users" do
        expect(body["users"].size).to eq(10)
      end

      it "have status code 200" do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "#create" do
    before { post :create, params: { user: params } }
    context "when params valid" do
      let(:params) { { first_name: "test", last_name: "test", email: "test111@example.com" } }

      it "have status code 200" do
        expect(response).to have_http_status(200)
      end

      it "new user saved to DB" do
        expect(body["user"]["email"]).to eq("test111@example.com")
      end

      it "increase 1 more user" do
        expect(User.count).to eq(11)
      end
    end

    context "when params invalid" do
      let(:params) { { first_name: "test", last_name: "test", email: "test" } }

      it "no user saved to DB" do
        expect(User.count).to eq(10)
      end

      it "have email error" do
        expect(body["errors"].first).to eq("Email is invalid")
      end
    end
  end

  describe "#update" do
    before { put :update, params: params }

    context "when params valid" do
      let(:params) { { id: User.first, user: { first_name: "thang95", email: "thang@example.com" } } }

      it "user update to DB" do
        expect(body["user"]["first_name"]).to eq("thang95")
        expect(body["user"]["email"]).to eq("thang@example.com")
        expect(User.first.email).to eq("thang@example.com")
      end
    end

    context "when params invalid" do
      let(:params) { { id: User.first, user: { first_name: "thang95", email: "thangexample.com" } } }

      it "user not updated" do
        expect(body["errors"].first).to eq("Email is invalid")
        expect(User.first.email).to_not eq("thangexampel.com")
      end
    end
  end

  describe "#destroy" do
    before { delete :destroy, params: { id: 1 } }

    context "when hit delete" do
      it "have status code 200" do
        expect(response).to have_http_status(200)
      end

      it "the 1st user will be deleted" do
        expect(User.find_by(id: 1)).to be_nil
      end

      it "have only 9 users left" do
        expect(User.count).to eq(9)
      end
    end
  end
end
