class AddMedianaToSamples < ActiveRecord::Migration
  def self.up
    add_column :samples, :mediana, :float
  end

  def self.down
    remove_column :samples, :mediana
  end
end
