class AddActiveSearchToSearch < ActiveRecord::Migration
  def change
  	add_column :searches, :active_search, :boolean, :default => false

  end
end
