class AddPublicoToControls < ActiveRecord::Migration
  def self.up
    add_column :controls, :publico, :boolean
  end

  def self.down
    remove_column :controls, :publico
  end
end
