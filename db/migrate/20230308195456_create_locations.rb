class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :query
      t.json :results
      t.json :weather
      t.timestamp :weather_expires_at

      t.timestamps
    end
  end
end
