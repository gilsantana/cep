# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101020042609) do

  create_table "additional_informations", :force => true do |t|
    t.integer  "sample_id"
    t.string   "informacao"
    t.string   "conteudo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "constants", :force => true do |t|
    t.integer  "tamanho"
    t.float    "a2"
    t.float    "d2"
    t.float    "d3"
    t.float    "d4"
    t.float    "a3"
    t.float    "c4"
    t.float    "b3"
    t.float    "b4"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "controls", :force => true do |t|
    t.string   "nome"
    t.text     "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "publico"
    t.float    "ls_padrao"
    t.float    "li_padrao"
  end

  create_table "items", :force => true do |t|
    t.integer  "sample_id"
    t.float    "valor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "limit_calculations", :force => true do |t|
    t.integer  "sample_id"
    t.string   "categoria"
    t.string   "tipo"
    t.string   "calculo"
    t.float    "valor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "samples", :force => true do |t|
    t.integer  "control_id"
    t.datetime "tempo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "media"
    t.float    "amplitude"
    t.float    "desvio_padrao"
    t.float    "mediana"
    t.float    "tamanho_da_amostra"
    t.float    "itens_defeituosos"
    t.string   "lote"
  end

  create_table "sheets", :force => true do |t|
    t.integer  "control_id"
    t.datetime "initial_time"
    t.float    "increment_value"
    t.string   "incremente_type"
    t.string   "arquivo_file_name"
    t.string   "arquivo_content_type"
    t.integer  "arquivo_file_size"
    t.datetime "arquivo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "processado"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.integer  "user_id"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
