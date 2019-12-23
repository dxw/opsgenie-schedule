require "spec_helper"

RSpec.describe Opsgenie::User do
  describe "#all" do
    let(:users) { described_class.all }

    it "returns all users" do
      stub = stub_user_list_request

      expect(users.count).to eq(2)
      expect(users.first).to be_a(Opsgenie::User)
      expect(users.first.id).to eq("b5b92115-bfe7-43eb-8c2a-e467f2e5ddc4")
      expect(users.first.username).to eq("john.doe@opsgenie.com")
      expect(users.first.full_name).to eq("john doe")

      expect(stub).to have_been_requested
    end
  end

  describe "#find_by_username" do
    before { stub_user_list_request }

    let(:user) { described_class.find_by_username(username) }

    context "when user exists" do
      let(:username) { "jane.doe@opsgenie.com" }

      it "returns a user" do
        expect(user).to be_a(Opsgenie::User)
        expect(user.username).to eq(username)
      end
    end

    context "when user does not exist" do
      let(:username) { "foo@opsgenie.com" }

      it "returns nil" do
        expect(user).to eq(nil)
      end
    end
  end

  describe "#find_by_id" do
    before { stub_user_list_request }

    let(:user) { described_class.find(id) }

    context "when user exists" do
      let(:id) { "e07c63f0-dd8c-4ad4-983e-4ee7dc600463" }

      it "returns a user" do
        expect(user).to be_a(Opsgenie::User)
        expect(user.id).to eq(id)
      end
    end

    context "when user does not exist" do
      let(:id) { "f321323" }

      it "returns nil" do
        expect(user).to eq(nil)
      end
    end
  end
end
