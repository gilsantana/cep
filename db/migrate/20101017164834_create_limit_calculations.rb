class CreateLimitCalculations < ActiveRecord::Migration
  def self.up
    create_table :limit_calculations do |t|
      t.references :sample
      t.string :categoria
      t.string :tipo
      t.string :calculo
      t.float :valor

      t.timestamps
    end
  end

  def self.down
    drop_table :limit_calculations
  end
end
