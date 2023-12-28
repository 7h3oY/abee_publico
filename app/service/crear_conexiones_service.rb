class CrearConexionesService
  attr_reader :errors
  def initialize(params:, cambio_inventario:)
    @params = params
    @cambio_inventario = cambio_inventario

  end

  def create
    create_conexiones

  end

  private



  def create_conexiones
    @Tiendas=@params[:tiendas]
     @Tiendas.each do | market|
      market[:productos]=@params[:productos];
      @conexion = @cambio_inventario.conexiones_marketplace.build(
        estado:'pendiente',
        tipo:'inventario',
        datos:market,
        tienda:market[:nombre]
      )
      @conexion.save
    end
    ConectarseMarketplaceJob.perform_later()
  end
end
