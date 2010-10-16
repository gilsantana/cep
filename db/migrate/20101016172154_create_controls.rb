class CreateControls < ActiveRecord::Migration
  def self.up
    create_table :controls do |t|
      t.string :nome
      t.text :descricao

      t.timestamps
    end
  end

  def self.down
    drop_table :controls
  end
end
