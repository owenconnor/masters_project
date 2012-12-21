class RenameName < ActiveRecord::Migration
	def change
    	rename_column :searches, :name, :search_name
  	end
end
