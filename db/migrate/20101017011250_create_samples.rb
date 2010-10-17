class CreateSamples < ActiveRecord::Migration
  def self.up
    create_table :samples do |t|
      t.references :control
      t.datetime :tempo

      t.timestamps
    end
  end

  def self.down
    drop_table :samples
  end
end
