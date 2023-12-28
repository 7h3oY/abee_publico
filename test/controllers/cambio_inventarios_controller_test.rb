require "test_helper"

class CambioInventariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cambio_inventario = cambio_inventarios(:one)
  end

  test "should get index" do
    get cambio_inventarios_url, as: :json
    assert_response :success
  end

  test "should create cambio_inventario" do
    assert_difference("CambioInventario.count") do
      post cambio_inventarios_url, params: { cambio_inventario: { cliente: @cambio_inventario.cliente, productos: @cambio_inventario.productos, tiendas: @cambio_inventario.tiendas } }, as: :json
    end

    assert_response :created
  end

  test "should show cambio_inventario" do
    get cambio_inventario_url(@cambio_inventario), as: :json
    assert_response :success
  end

  test "should update cambio_inventario" do
    patch cambio_inventario_url(@cambio_inventario), params: { cambio_inventario: { cliente: @cambio_inventario.cliente, productos: @cambio_inventario.productos, tiendas: @cambio_inventario.tiendas } }, as: :json
    assert_response :success
  end

  test "should destroy cambio_inventario" do
    assert_difference("CambioInventario.count", -1) do
      delete cambio_inventario_url(@cambio_inventario), as: :json
    end

    assert_response :no_content
  end
end
