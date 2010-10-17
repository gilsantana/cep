class AddAmplitudeToSamples < ActiveRecord::Migration
  def self.up
    add_column :samples, :amplitude, :float
  end

  def self.down
    remove_column :samples, :amplitude
  end
end
