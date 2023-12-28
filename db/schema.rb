# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_12_05_000641) do
  create_table "cambio_inventarios", force: :cascade do |t|
    t.string "order_id"
    t.string "organization_id"
    t.string "organization"
    t.text "tiendas"
    t.text "productos"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conexiones_marketplaces", force: :cascade do |t|
    t.string "estado", default: "pendiente"
    t.string "tienda"
    t.string "tipo"
    t.integer "cambio_inventario_id"
    t.text "datos"
    t.text "productos"
    t.text "ultima_respuesta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cambio_inventario_id"], name: "index_conexiones_marketplaces_on_cambio_inventario_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "tienda"
    t.string "organization_id"
    t.text "token_actual"
    t.text "datos_respuesta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "conexiones_marketplaces", "cambio_inventarios"
end
