class ConectarseMarketplaceJob < ApplicationJob
  queue_as :default


  def perform
    conexiones=ConexionesMarketplace.where(estado: 'pendiente')
    conexiones.each do | coneccion|
      tipo = coneccion[:tipo]
      organization_id = coneccion[:organization_id] #Abee
      tienda = coneccion[:tienda]
      datos = coneccion[:datos]
      productos = datos['productos']
      estado='pendiente'

       if tipo=='inventario'

          if tienda=='falabella'
              action_signature = 'ProductUpdate'
              api_falabella =FalabellaUpdate.new(userID: datos['UserID'], apitoken:datos['api_key'], action: 'ProductUpdate')
              ultima_respuesta= api_falabella.actualizar_productos(productos: datos['productos'])

              estado= (ultima_respuesta['SuccessResponse'])?  'realizada' : 'pendiente'


          end

          if tienda=='mercado_libre'
            api_meli =ApiMercadolibreService.new(organization_id: organization_id, market_id: datos['vendedor_id'], market_code: datos['vendedor_code'])
              ultima_respuesta= api_meli.actualizar_inventario(productos: datos['productos'])

                if( ultima_respuesta==Hash)
                estado= ( ultima_respuesta.key?('error') )?  'pendiente' : 'realizada'
                else
                  estado= ( ultima_respuesta[0]['id'])?  'realizada' : 'pendiente'
                end
          end



          if tienda=='woocommerce'
            api_wc=ApiWoocommerceService.new(url: datos['url'], consumer_key: datos['consumer_key'], consumer_secret: datos['consumer_secret'])
            ultima_respuesta= api_wc.actualizar_inventario(productos: datos['productos'])

            if( ultima_respuesta==Hash)
              estado= ( ultima_respuesta.key?('error') )?  'pendiente' : 'realizada'
            else
                estado= ( ultima_respuesta[0]['id'])?  'realizada' : 'pendiente'
            end
          end

          coneccion.update(ultima_respuesta:ultima_respuesta, estado:estado )
        end



    elsif tipo =='shipping'
          if tienda=='shopify'
            api_shopify =ShoppifyShipping.new(
              nombre_tienda: datos['nombreTienda'], 
              tienda_url:datos['tienda_url'], 
              token_tienda: datos["tokenTienda"], 
              refresh_token:datos["refreshToken"]
              )
            shopify_update= api_shopify.actualizar_shipping(
              order_id: datos["orderID"], 
              status_shipping: datos["statusShipping"], 
              fulfillments: datos["productos"]
              )
          end

          if tienda=='mercado_libre'


          end

          if tienda=='wc'

          end


      end 

  end

end
