require "test_helper"

class TokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @token = tokens(:one)
  end

  test "should get index" do
    get tokens_url, as: :json
    assert_response :success
  end

  test "should create token" do
    assert_difference("Token.count") do
      post tokens_url, params: { token: { datos_respuesta: @token.datos_respuesta, organization_id: @token.organization_id, tienda: @token.tienda, token_actual: @token.token_actual } }, as: :json
    end

    assert_response :created
  end

  test "should show token" do
    get token_url(@token), as: :json
    assert_response :success
  end

  test "should update token" do
    patch token_url(@token), params: { token: { datos_respuesta: @token.datos_respuesta, organization_id: @token.organization_id, tienda: @token.tienda, token_actual: @token.token_actual } }, as: :json
    assert_response :success
  end

  test "should destroy token" do
    assert_difference("Token.count", -1) do
      delete token_url(@token), as: :json
    end

    assert_response :no_content
  end
end
