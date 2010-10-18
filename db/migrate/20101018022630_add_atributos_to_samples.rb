class AddAtributosToSamples < ActiveRecord::Migration
  def self.up
    add_column :samples, :tamanho_da_amostra, :float
    add_column :samples, :itens_defeituosos, :float
  end

  def self.down
    remove_column :samples, :itens_defeituosos
    remove_column :samples, :tamanho_da_amostra
  end
end
