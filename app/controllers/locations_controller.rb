require "weather_kit"

class LocationsController < ApplicationController
  before_action :set_location, only: %i[ show edit update destroy ]

  def search
    @location = Location.find_or_create_by!(query: location_params[:query])

    # Geocode the address query and cache the results.
    unless @location.results
      @location.update results: geocode_query["results"]
    end

    redirect_to @location
  end

  # GET /locations or /locations.json
  def index
    @locations = Location.all
  end

  # GET /locations/1 or /locations/1.json
  def show
    # Attempt to fetch weather for the Location if weather data is expired and coordindates are known
    if @location.weather_expired? && coordinate_present?(@location)
      # Fetch weather with coordindates.
      weather = WeatherClient.current_weather(
        latitude: coordinate["latitude"],
        longitude: coordinate["longitude"]
      )
      @location.update weather: weather
    end
  end

  # PATCH/PUT /locations/1 or /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to location_url(@location), notice: "Location was successfully updated." }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1 or /locations/1.json
  def destroy
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url, notice: "Location was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def location_params
      params.require(:location).permit(:query)
    end

    def geocode_query
      response = MapsClient.geocode(location_params[:query])
      response.parsed_response
    end

    # Use coordinates of first result first result for simplicity.
    def coordinate_present?(location)
      location && location.results && location.results[0] && location.results[0]["coordinate"]
    end

    def coordinate
      return nil unless coordinate_present?(@location)
      @location.results[0]["coordinate"]
    end
end
