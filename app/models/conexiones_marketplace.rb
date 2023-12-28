class ConexionesMarketplace < ApplicationRecord
    belongs_to :cambio_inventario
    serialize :datos, JSON
    serialize :ultima_respuesta, JSON
end
