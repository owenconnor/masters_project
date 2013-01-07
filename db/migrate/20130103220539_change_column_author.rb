class ChangeColumnAuthor < ActiveRecord::Migration
  def up
  	change_column :authors, :trusted_uploader_rank, :integer, :default => 0
  end

  def down
  	change_column :authors, :trusted_uploader_rank, :integer
  end
end
