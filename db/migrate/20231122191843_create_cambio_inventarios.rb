class CreateCambioInventarios < ActiveRecord::Migration[7.0]
  def change
    create_table "cambio_inventarios", force: :cascade do |t|
      t.string "order_id"
      t.string "organization_id"
      t.string "organization"
      t.text "tiendas"
      t.text "productos"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
