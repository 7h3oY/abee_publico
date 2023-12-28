class ConexionesMarketplacesController < ApplicationController
  before_action :set_conexiones_marketplace, only: %i[ show update destroy ]

  # GET /conexiones_marketplaces
  def index
    @conexiones_marketplaces = ConexionesMarketplace.all

    render json: @conexiones_marketplaces
  end

  # GET /conexiones_marketplaces/1
  def show
    render json: @conexiones_marketplace
  end

  # POST /conexiones_marketplaces
  def create
    @conexiones_marketplace = ConexionesMarketplace.new(conexiones_marketplace_params)

    if @conexiones_marketplace.save
      render json: @conexiones_marketplace, status: :created, location: @conexiones_marketplace
    else
      render json: @conexiones_marketplace.errors, status: :unprocessable_entity
    end
  end

  def realizar_conexiones_pendientes
    ConectarseMarketplaceJob.perform_later()
  end

  # PATCH/PUT /conexiones_marketplaces/1
  def update
    if @conexiones_marketplace.update(conexiones_marketplace_params)
      render json: @conexiones_marketplace
    else
      render json: @conexiones_marketplace.errors, status: :unprocessable_entity
    end
  end

  # DELETE /conexiones_marketplaces/1
  def destroy
    @conexiones_marketplace.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conexiones_marketplace
      @conexiones_marketplace = ConexionesMarketplace.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def conexiones_marketplace_params
      params.require(:conexiones_marketplace).permit(:estado, :tipo, :tienda, :datos, :ultima_respuesta)
    end
end
