class AddMediaToSamples < ActiveRecord::Migration
  def self.up
    add_column :samples, :media, :float
  end

  def self.down
    remove_column :samples, :media
  end
end
