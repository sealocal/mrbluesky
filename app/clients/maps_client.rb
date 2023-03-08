# Usage:
#
# maps_client = MapsClient.new("Seattle, WA")
# maps_client.maps

# puts response.body, response.code, response.message, response.headers.inspect
# maps_client = MapsClient.new("stackoverflow", 1)
# puts maps_client.questions
# puts maps_client.users
class MapsClient
  include HTTParty
  base_uri 'https://maps-api.apple.com/v1/'

  def initialize(q)
    @options = { query: { q: q, loc: loc } }
  end

  def geocode
    raise ArgumentError.new("No location string `q` provided.") if @options[:q].blank?
    begin
      self.class.get("geocode", @options)
    rescue
      Rails.logger.error("Failed to geocode q: #{@options[:q]}")
    end
  end

  def reverse_geocode
    raise ArgumentError.new("No coordinate string `loc` provided.") if @options[:loc].blank?
    begin
      self.class.get("reverseGeocode", @options)
    rescue
      Rails.logger.error("Failed to reverse geocode loc: #{@options[:loc]}")
    end
  end
end
