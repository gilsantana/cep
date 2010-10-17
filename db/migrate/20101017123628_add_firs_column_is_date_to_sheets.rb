class AddFirsColumnIsDateToSheets < ActiveRecord::Migration
  def self.up
    add_column :sheets, :first_column_is_date, :boolean
  end

  def self.down
    remove_column :sheets, :first_column_is_date
  end
end
