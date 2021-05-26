module ControllerSpecHelper
  # Parse JSON response to ruby hash
  def body
    JSON.parse(response.body)
  end
end
