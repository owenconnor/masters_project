class RemoveVicinityFromYtsearchresults < ActiveRecord::Migration
  def up
  	remove_column :searches, :vicinity
  end

  def down
  	add_column :searches, :vicinity, :string
  end
end
