require 'rails_helper'

RSpec.describe LoanRequestsController, type: :controller do
  describe "GET #new" do
    it "assigns a new LoanRequest to @loan_request" do
      get :new
      expect(assigns(:loan_request)).to be_a_new(LoanRequest)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new loan request" do
        expect {
          post :create, params: { loan_request: FactoryBot.attributes_for(:loan_request) }
        }.to change(LoanRequest, :count).by(1)
      end

      it "redirects to root_path" do
        post :create, params: { loan_request: FactoryBot.attributes_for(:loan_request) }
        expect(response).to redirect_to(root_path)
      end

      it "sets flash[:notice]" do
        post :create, params: { loan_request: FactoryBot.attributes_for(:loan_request) }
        expect(flash[:notice]).to be_present
      end

      it "responds with JSON success" do
        post :create, format: :json, params: { loan_request: FactoryBot.attributes_for(:loan_request) }
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['redirect_url']).to eq(root_path)
      end
    end

    context "with invalid attributes" do
      it "does not create a new loan request" do
        expect {
          post :create, params: { loan_request: FactoryBot.attributes_for(:loan_request, email: nil) }
        }.not_to change(LoanRequest, :count)
      end

      it "sets flash[:alert]" do
        post :create, params: { loan_request: FactoryBot.attributes_for(:loan_request, email: nil) }
        expect(flash[:alert]).to be_present
      end
    end
  end
end
