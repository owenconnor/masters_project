class AddDateRangeToSearches < ActiveRecord::Migration
  def change
  	add_column :searches, :date_range, :string
  end
end
