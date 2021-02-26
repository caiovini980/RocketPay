defmodule RocketpayWeb.AccountsController do
  use RocketpayWeb, :controller

  alias Rocketpay.Account
  alias Rocketpay.Accounts.Transferences.Responses, as: TransferenceResponse

  action_fallback RocketpayWeb.FallbackController

  def deposit(connection, params) do
    with {:ok, %Account{} = account} <- Rocketpay.deposit(params) do
      connection
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  def withdraw(connection, params) do
    with {:ok, %Account{} = account} <- Rocketpay.withdraw(params) do
      connection
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  def transfer(connection, params) do
    with {:ok, %TransferenceResponse{} = transfer} <- Rocketpay.transfer(params) do
      connection
      |> put_status(:ok)
      |> render("transfer.json", transfer: transfer)
    end
  end

end
