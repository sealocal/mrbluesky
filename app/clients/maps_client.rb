require "weather_kit"

# Usage:
#
# response = MapsClient.geocode("Seattle")
# puts response.body, response.code, response.message, response.headers.inspect
class MapsClient
  include HTTParty
  base_uri 'https://maps-api.apple.com/v1'

  def options
    @options
  end

  def initialize(q: nil)
    @options = {
      query: { q: q },
      headers: { "Authorization" => "Bearer #{access_token}" },
      debug_output: $stdout
    }
  end

  def self.geocode(q)
    raise ArgumentError.new("No query string `q` provided.") if q.blank?
    response = MapsClient.new(q: q).geocode
  end

  def geocode
    begin
      self.class.get("/geocode", @options)
    rescue
      STDOUT.puts "Failed to geocode @options: #{@options}"
    end
  end

  private
    def access_token
      @access_token ||= begin
        response = self.class.get("/token", { headers: { "Authorization" => "Bearer #{WeatherKit::JWT.call}" }, debug_output: $stdout })
        response.parsed_response["accessToken"]
      rescue
        STDOUT.puts "Failed to get token for MapsClient."
      end
    end
end
