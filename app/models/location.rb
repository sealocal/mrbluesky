class Location < ApplicationRecord
  WEATHER_EXIRATION_DURATION = 30

  before_save :referesh_expires_at

  def weather_expired?
    return true if weather.blank? || weather_expires_at.blank?
    weather_expires_at.past?
  end

  private
    def referesh_expires_at
      expires_at = (Time.now + WEATHER_EXIRATION_DURATION.minutes) if weather_changed?
    end
end
