class CreateAdditionalInformations < ActiveRecord::Migration
  def self.up
    create_table :additional_informations do |t|
      t.references :sample
      t.string :informacao
      t.string :conteudo

      t.timestamps
    end
  end

  def self.down
    drop_table :additional_informations
  end
end
