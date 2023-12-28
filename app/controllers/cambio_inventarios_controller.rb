class CambioInventariosController < ApplicationController
  before_action :set_cambio_inventario, only: %i[ show update destroy ]

  # GET /cambio_inventarios
  def index
    @cambio_inventarios = CambioInventario.all
    render json: @cambio_inventarios
  end


  def show

   id=@cambio_inventario[:id]
    @conexiones=ConexionesMarketplace.where(cambio_inventario: id)


    hash = {
      "id":  id,
      "order_id":  @cambio_inventario[:order_id],
      "organization_id":  @cambio_inventario[:organization_id],
      "organization":  @cambio_inventario[:organization],
      "tiendas":  @cambio_inventario[:tiendas],
      "productos":  @cambio_inventario[:productos],
      "created_at":  @cambio_inventario[:created_at],
      "updated_at":  @cambio_inventario[:updated_at],
      "conexiones":  @conexiones,
    }
    render json: hash

  end

  # POST /cambio_inventarios
  def create
    @parametros =params

    @cambio_inventario = CambioInventario.new(cambio_inventario_params)

    if @cambio_inventario.save
      #cambio_inventario = CambioInventario.find(@cambio_inventario.id)
      conexiones =CrearConexionesService.new(params: params, cambio_inventario: @cambio_inventario)
      conexiones.create
      render json: @cambio_inventario, status: :created, location: @cambio_inventario

    else
      render json: @cambio_inventario.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cambio_inventarios/1
  def update
    if @cambio_inventario.update(cambio_inventario_params)
      render json: @cambio_inventario
    else
      render json: @cambio_inventario.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cambio_inventarios/1
  def destroy
    @cambio_inventario.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cambio_inventario
      @cambio_inventario = CambioInventario.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cambio_inventario_params

      params.require(:cambio_inventario).permit(:order_id,:organization_id,:organization,
      tiendas:[ :nombre,:UserID,:api_key,:vendedor_id ,:vendedor_code,:url,:consumer_key ,:consumer_secret],
      productos: [  :sku, :cantidad, :stock]
      )

    end
end
