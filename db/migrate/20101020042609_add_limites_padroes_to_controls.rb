class AddLimitesPadroesToControls < ActiveRecord::Migration
  def self.up
    add_column :controls, :ls_padrao, :float
    add_column :controls, :li_padrao, :float
  end

  def self.down
    remove_column :controls, :li_padrao
    remove_column :controls, :ls_padrao
  end
end
