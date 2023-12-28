require "test_helper"

class ConexionesMarketplacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @conexiones_marketplace = conexiones_marketplaces(:one)
  end

  test "should get index" do
    get conexiones_marketplaces_url, as: :json
    assert_response :success
  end

  test "should create conexiones_marketplace" do
    assert_difference("ConexionesMarketplace.count") do
      post conexiones_marketplaces_url, params: { conexiones_marketplace: { datos: @conexiones_marketplace.datos, estado: @conexiones_marketplace.estado, tipo: @conexiones_marketplace.tipo } }, as: :json
    end

    assert_response :created
  end

  test "should show conexiones_marketplace" do
    get conexiones_marketplace_url(@conexiones_marketplace), as: :json
    assert_response :success
  end

  test "should update conexiones_marketplace" do
    patch conexiones_marketplace_url(@conexiones_marketplace), params: { conexiones_marketplace: { datos: @conexiones_marketplace.datos, estado: @conexiones_marketplace.estado, tipo: @conexiones_marketplace.tipo } }, as: :json
    assert_response :success
  end

  test "should destroy conexiones_marketplace" do
    assert_difference("ConexionesMarketplace.count", -1) do
      delete conexiones_marketplace_url(@conexiones_marketplace), as: :json
    end

    assert_response :no_content
  end
end
