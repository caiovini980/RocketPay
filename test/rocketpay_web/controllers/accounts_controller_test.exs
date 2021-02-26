defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true #funcionalidades de controllers (connection)

  alias Rocketpay.Account
  alias Rocketpay.User

  # -------------------- Testes de controller DEPOSIT --------------------
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

  # -------------------- Testes de controller WITHDRAW --------------------
  describe "withdraw/2" do
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

    test "when all params are valid but dont have money to withdraw, return error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "10"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:bad_request)

        assert %{
          "message" => %{
            "balance" => ["is invalid"]}
        } = response
    end

    test "when all params are valid and have money, make withdraw", %{conn: conn, account_id: account_id} do
      params = %{"value" => "10"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:ok)

        assert %{
          "message" => "Balance successfully changed!",
          "user" => %{
            "balance" => "0.00",
            "id" => _id
          }
        } = response
    end
  end

  # -------------------- Testes de controller Transfer --------------------
  """
  describe "transfer/3" do
    setup %{conn: conn} do

      # -------------- Params from --------------
      params_from = %{
        name: "Alessandro",
        password: "123456",
        nickname: "mainJinx",
        email: "mamaco@mamaco.com",
        age: 24
      }

      {:ok, %User{account: %Account{id: account_id_from}}} = Rocketpay.create_user(params_from)

      conn = put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")

      {:ok, conn: conn, account_id: account_id_from}

      # -------------- Params to --------------
      params_to = %{
        name: "Matthews",
        password: "123456",
        nickname: "jojofag21",
        email: "manfius@manfius.com",
        age: 22
      }

      {:ok, %User{account: %Account{id: account_id_to}}} = Rocketpay.create_user(params_to)

      {:ok, conn: conn, account_id: account_id_to}

    end


    test "when both users are valid, make a transference", %{conn: conn, account_id_from: account_id_from, account_id_to: account_id_to} do
      params_deposit = %{"value" => "10"}

      params_transfer = %{
        "value" => "5",
        "from" => account_id_from,
        "to" => account_id_to
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id_from, params_deposit))
        |> post(Routes.accounts_path(conn, :transfer, account_id_to, params_transfer))
        |> json_response(:ok)

        assert response = "banana"
    end
  end
  """
end
