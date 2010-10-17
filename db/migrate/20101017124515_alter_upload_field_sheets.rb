class AlterUploadFieldSheets < ActiveRecord::Migration
  def self.up
    rename_column :sheets, :file_file_name, :arquivo_file_name
    rename_column :sheets, :file_content_type, :arquivo_content_type
    rename_column :sheets, :file_file_size, :arquivo_file_size
    rename_column :sheets, :file_updated_at, :arquivo_updated_at
  end

  def self.down
    rename_column :sheets, :arquivo_file_name, :file_file_name
    rename_column :sheets, :arquivo_content_type, :file_content_type
    rename_column :sheets, :arquivo_file_size, :file_file_size
    rename_column :sheets, :arquivo_updated_at, :file_updated_at
  end
end
