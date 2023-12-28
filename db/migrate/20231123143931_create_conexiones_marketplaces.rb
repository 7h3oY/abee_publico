class CreateConexionesMarketplaces < ActiveRecord::Migration[7.0]
  def change
    create_table :conexiones_marketplaces do |t|
      t.string "estado", default: "pendiente"
      t.string "tienda"

      t.string "tipo"
      t.integer "cambio_inventario_id", null: true
      t.index ["cambio_inventario_id"], name: "index_conexiones_marketplaces_on_cambio_inventario_id"
      t.string "organization_id"
      t.text "datos"
      t.text "productos"
      t.text "ultima_respuesta"

      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false

    end
    add_foreign_key "conexiones_marketplaces", "cambio_inventarios"
  end

end
