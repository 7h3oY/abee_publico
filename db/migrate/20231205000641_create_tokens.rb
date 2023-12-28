class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.string :tienda
      t.string :organization_id
      t.text :token_actual
      t.text :datos_respuesta
      t.timestamps
    end
  end
end
