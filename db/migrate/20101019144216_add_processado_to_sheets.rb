class AddProcessadoToSheets < ActiveRecord::Migration
  def self.up
    add_column :sheets, :processado, :boolean
  end

  def self.down
    remove_column :sheets, :processado
  end
end
