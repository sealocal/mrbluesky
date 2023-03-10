require "weather_kit"

# Usage:
#
# response = WeatherClient.current_weather("Seattle, WA")
# puts response.body, response.code, response.message, response.headers.inspect
class WeatherClient
  include HTTParty
  WEATHER_CLIENT_JWT = WeatherKit::JWT.call
  LANGUAGE = "en"
  TIMEZONE = "America/Los_Angeles"
  base_uri 'https://weatherkit.apple.com/api/v1'

  def initialize(latitude:, longitude:)
    @latitude = latitude
    @longitude = longitude

    @options = {
      query: {
        # currentAsOf date-time
        # The time to obtain current conditions. Defaults to now.

        # dailyEnd date-time
        # The time to end the daily forecast. If this parameter is absent, daily forecasts run for 10 days.

        # dailyStart date-time
        # The time to start the daily forecast. If this parameter is absent, daily forecasts start on the current day.

        # dataSets [DataSet]
        # A comma-delimited list of data sets to include in the response.
        dataSets: "currentWeather,forecastDaily",

        # hourlyEnd date-time
        # The time to end the hourly forecast. If this parameter is absent, hourly forecasts run 24 hours or the length of the daily forecast, whichever is longer.

        # hourlyStart date-time
        # The time to start the hourly forecast. If this parameter is absent, hourly forecasts start on the current hour.

        # timezone string
        # (Required) The name of the timezone to use for rolling up weather forecasts into daily forecasts.
        timezone: TIMEZONE,
      },
      headers: { "Authorization" => "Bearer #{WEATHER_CLIENT_JWT}" },
      debug_output: $stdout
    }
  end

  def self.current_weather(latitude:, longitude:)
    raise ArgumentError.new("No query string `latitude` provided.") if latitude.blank?
    raise ArgumentError.new("No query string `longitude` provided.") if longitude.blank?
    response = WeatherClient.new(latitude: latitude, longitude: longitude).current_weather
    response
  end

  def current_weather
    begin
      self.class.get("/weather/#{"LANGUAGE"}/#{@latitude}/#{@longitude}", @options)
    rescue
      STDOUT.puts "Failed to get current_weather with language: #{LANGUAGE}, latitude: #{latitude}, longitude: #{longitude}, and @options #{@options}"
    end
  end
end
