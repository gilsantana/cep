class DeleteFieldsForSheets < ActiveRecord::Migration
  def self.up
    remove_column :sheets, :first_column_is_label
    remove_column :sheets, :first_column_is_date
    remove_column :sheets, :firs_line_is_label
  end

  def self.down
  end
end
