class CambioInventario < ApplicationRecord
    has_many :conexiones_marketplace
    serialize :productos, JSON
    serialize :tiendas, JSON
end
