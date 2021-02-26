defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true #funcionalidades de controllers (connection)

  alias Rocketpay.Account
  alias Rocketpay.User

  # -------------------- Testes de controller --------------------
  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
          name: "Alessandro",
          password: "123456",
          nickname: "mainJinx",
          email: "mamaco@mamaco.com",
          age: 24
        }

        {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

        conn = put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")

        {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
        "message" => "Balance successfully changed!",
        "user" => %{
          "balance" => "50.00",
          "id" => _id
        }
      } = response
    end

    test "when there are invalid params, return an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid deposit value!"}

      assert response == expected_response
    end
  end
end
