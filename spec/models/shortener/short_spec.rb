require "rails_helper"

RSpec.describe Shortener::Short, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  describe "validations" do
    it { is_expected.to validate_presence_of(:token) }
    it { is_expected.to validate_presence_of(:original_url) }
    it { is_expected.to validate_presence_of(:expire_at) }
    it { is_expected.to validate_length_of(:token).is_equal_to(6) }
  end

  describe "validations sensible to other attributes" do
    subject(:short) do
      described_class.new(
        token: "aToken",
        original_url: "https://test.example.com/long",
        expire_at: Date.current + 1.day
      )
    end

    it { is_expected.to validate_uniqueness_of(:token) }
  end

  describe "#expired?" do
    subject(:call) { short.expired? }

    around do |example|
      original_timezone = ENV["TZ"]
      ENV["TZ"] = "America/Sao_Paulo" # UTC-03:00

      travel_to(Time.utc(2026, 1, 2)) { example.run }
    ensure
      ENV["TZ"] = original_timezone
    end

    context "with a short expired today" do
      let(:short) do
        described_class.create!(
          original_url: "https://test.example.com/long",
          token: "ABC123",
          expire_at: Date.new(2026, 1, 2)
        )
      end

      it { is_expected.to be_truthy }
    end

    context "with an expired short" do
      let(:short) do
        described_class.create!(
          original_url: "https://test.example.com/long",
          token: "ABC123",
          expire_at: Date.new(2026, 1, 1)
        )
      end

      it { is_expected.to be_truthy }
    end

    context "with a not expired short" do
      let(:short) do
        described_class.create!(
          original_url: "https://test.example.com/long",
          token: "ABC123",
          expire_at: Date.new(2026, 1, 3)
        )
      end

      it { is_expected.to be_falsey }
    end
  end
end
