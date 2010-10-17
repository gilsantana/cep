class CreateSheets < ActiveRecord::Migration
  def self.up
    create_table :sheets do |t|
      t.references :control
      t.boolean :first_column_is_label
      t.bollean :firs_line_is_label
      t.datetime :initial_time
      t.float :increment_value
      t.string :incremente_type
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :sheets
  end
end
