module WebMockHelpers
  def stub_get_request(url, body)
    stub_request(:get, url)
      .to_return(
        body: body.to_json,
        headers: {"Content-Type" => "application/json"}
      )
  end

  def stub_user_list_request
    body = JSON.parse File.read(File.join("spec", "fixtures", "users.json"))
    url = "https://api.opsgenie.com/v2/users?limit=500"
    stub_get_request(url, body)
  end

  def stub_schedule_show_request(url = "https://api.opsgenie.com/v2/schedules/b8e97704-0e9d-41b5-b27c-9d9027c83943?identifierType=id")
    body = JSON.parse File.read(File.join("spec", "fixtures", "schedule.json"))
    stub_get_request(url, body)
  end
end
