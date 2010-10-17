class CreateConstants < ActiveRecord::Migration
  def self.up
    create_table :constants do |t|
      t.integer :tamanho
      t.float :a2
      t.float :d2
      t.float :d3
      t.float :d4
      t.float :a3
      t.float :c4
      t.float :b3
      t.float :b4

      t.timestamps
    end
  end

  def self.down
    drop_table :constants
  end
end
