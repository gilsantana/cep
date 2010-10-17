class AddDesvioPadraoToSamples < ActiveRecord::Migration
  def self.up
    add_column :samples, :desvio_padrao, :float
  end

  def self.down
    remove_column :samples, :desvio_padrao
  end
end
