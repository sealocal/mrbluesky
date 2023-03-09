require 'openssl'
require 'httparty'
require 'jwt'

module WeatherKit

  module JWT
    # Located in Apple Developer Account
    TEAM_ID = ENV["WEATHER_KIT_JWT_TEAM_ID"]
    KEY_ID = ENV["WEATHER_KIT_JWT_KEY_ID"]
    SERVICE_ID = ENV["WEATHER_KIT_SERVICE_ID"]

    # Path to private key of KEY_ID (.p8 file downloade drom Apple Developer Account)
    KEY_PATH = ENV["WEATHER_KIT_KEY_PATH"]
    # Read the key from a file path to create an ECDSA key
    ENCRYPTED_PRIVATE_KEY = OpenSSL::PKey::EC.new(File.read(KEY_PATH))

    # Heavily inspired by these resources:
    # https://developer.apple.com/forums/thread/707418?answerId=716697022#716697022
    # https://developer.apple.com/forums/thread/707418?answerId=716724022#716724022
    def self.call
      # Create a JWT for accessing WeatherKit
      jwt = ::JWT.encode({
        iss: TEAM_ID,
        iat: Time.now.to_i,
        exp: Time.now.to_i + (60 * 30), # expires in 30 min
        sub: SERVICE_ID,
      }, ENCRYPTED_PRIVATE_KEY, 'ES256', {
        kid: KEY_ID,
        id: "#{TEAM_ID}.#{SERVICE_ID}",
      })

      jwt
    end
  end
end

# # Example HTTP request with signed JWT
# # $ docked rails bundle exec ruby lib/weather_client.rb
# #
# # Path params
# LANG = "en"
# LAT = "37.331656"
# LONG = "-122.0301426"
# # Query params
# TZ = "America/Los_Angeles"
# DATASETS = "currentWeather,forecastDaily"

# jwt = WeatherKit::JWT.call
# decoded_token = JWT.decode jwt, WeatherKit::JWT::ENCRYPTED_PRIVATE_KEY, true, { algorithm: 'ES256' }
# p decoded_token

# # Use HTTParty to make the request to WeatherKit
# response = HTTParty.get(
#     "https://weatherkit.apple.com/api/v1/weather/#{LANG}/#{LAT}/#{LONG}?dataSets=#{DATASETS}&timezone=#{TZ}",
#     headers: { "Authorization" => "Bearer #{jwt}" },
#     # debug_output: $stdout
# )
# STDOUT.puts response.parsed_response.to_json
