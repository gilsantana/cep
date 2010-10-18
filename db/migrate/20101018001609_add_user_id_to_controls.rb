class AddUserIdToControls < ActiveRecord::Migration
  def self.up
    add_column :controls, :user_id, :integer
  end

  def self.down
    remove_column :controls, :user_id
  end
end
