class AddNotificationCountToSearches < ActiveRecord::Migration
  def change
  	add_column :searches, :notification_count, :integer
  end
end
