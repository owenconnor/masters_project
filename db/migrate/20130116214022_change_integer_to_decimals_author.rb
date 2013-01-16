class ChangeIntegerToDecimalsAuthor < ActiveRecord::Migration
  def change
    change_column :authors, :trusted_uploader_rank, :integer, :null => false, :default => 1
    
  end
end
