class Token < ApplicationRecord
  serialize :datos_respuesta, JSON
end
