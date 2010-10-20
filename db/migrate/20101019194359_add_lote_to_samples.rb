class AddLoteToSamples < ActiveRecord::Migration
  def self.up
    add_column :samples, :lote, :string
  end

  def self.down
    remove_column :samples, :lote
  end
end
