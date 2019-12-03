require "spec_helper"

RSpec.describe Opsgenie::User do
  describe "#all" do
    let!(:stub) do
      stub_request(:get, url)
        .to_return(
          body: body.to_json,
          headers: {"Content-Type" => "application/json"}
        )
    end
    let(:url) { "https://api.opsgenie.com/v2/users?limit=500" }
    let(:body) do
      {
        totalCount: 8,
        data: [
          {
            blocked: false,
            verified: false,
            id: "b5b92115-bfe7-43eb-8c2a-e467f2e5ddc4",
            username: "john.doe@opsgenie.com",
            fullName: "john doe",
            role: {
              id: "Admin",
              name: "Admin",
            },
            timeZone: "Europe/Kirov",
            locale: "en_US",
            userAddress: {
              country: "",
              state: "",
              city: "",
              line: "",
              zipCode: "",
            },
            createdAt: "2017-05-12T08:34:30.283Z",
          },
          {
            blocked: false,
            verified: false,
            id: "e07c63f0-dd8c-4ad4-983e-4ee7dc600463",
            username: "jane.doe@opsgenie.com",
            fullName: "jane doe",
            role: {
              id: "Admin",
              name: "Admin",
            },
            timeZone: "Europe/Moscow",
            locale: "en_GB",
            tags: ["tag1", "tag3"],
            userAddress: {
              country: "US",
              state: "Indiana",
              city: "Terre Haute",
              line: "567 Stratford Park",
              zipCode: "47802",
            },
            details: {
              detail1key: ["detail1dvalue1", "detail1value2"],
              detail2key: ["detail2value"],
            },
            createdAt: "2017-05-12T09:39:14.41Z",
          },
        ],
        paging: {
          prev: "http://api.opsgenie.com/v2/users?limit=2&offset=1&order=DESC&sort=fullName&query=role%3Aadmin",
          next: "http://api.opsgenie.com/v2/users?limit=2&offset=5&order=DESC&sort=fullName&query=role%3Aadmin",
          first: "http://api.opsgenie.com/v2/users?limit=2&offset=0&order=DESC&sort=fullName&query=role%3Aadmin",
          last: "http://api.opsgenie.com/v2/users?limit=2&offset=6&order=DESC&sort=fullName&query=role%3Aadmin",
        },
        took: 0.261,
        requestId: "d2c50d0c-1c44-4fa5-99d4-20d1e7ca9938",
      }
    end
    let(:users) { described_class.all }

    it "returns all users" do
      expect(users.count).to eq(2)
      expect(users.first).to be_a(Opsgenie::User)
      expect(users.first.id).to eq("b5b92115-bfe7-43eb-8c2a-e467f2e5ddc4")
      expect(users.first.username).to eq("john.doe@opsgenie.com")
      expect(users.first.full_name).to eq("john doe")

      expect(stub).to have_been_requested
    end
  end
end
