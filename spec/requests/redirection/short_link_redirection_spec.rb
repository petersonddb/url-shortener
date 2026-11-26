require 'rails_helper'

RSpec.describe "Short Link Redirection", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  describe "GET /r/:token" do
    subject(:make_request) { get("/r/#{token}") }

    around do |example|
      original_timezone = ENV["TZ"]
      ENV["TZ"] = "America/Sao_Paulo" # UTC-03:00

      travel_to(Time.utc(2026, 1, 2)) { example.run }
    ensure
      ENV["TZ"] = original_timezone
    end

    context "when given a valid short" do
      let(:token) { "ABC123" }

      before do
        Shortener::Short.create!(
          original_url: "https://test.example.com/long",
          token: "ABC123",
          expire_at: Date.new(2026, 1, 3)
        )
      end

      it "redirects" do
        make_request

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to("https://test.example.com/long")
      end
    end

    context "when given a not existent short" do
      let(:token) { "ABC123" }

      it "fails" do
        make_request

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when given short has expired" do
      let(:token) { "ABC123" }

      before do
        Shortener::Short.create!(
          original_url: "https://test.example.com/long",
          token: "ABC123",
          expire_at: Date.new(2026, 1, 2)
        )
      end

      it "fails" do
        make_request

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
