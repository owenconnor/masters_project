class AddGeolocationToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :geolocation, :string
  end
end
