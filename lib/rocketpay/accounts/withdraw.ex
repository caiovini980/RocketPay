defmodule Rocketpay.Accounts.Withdraw do

  alias Rocketpay.Repo
  alias Rocketpay.Accounts.Operation

  def call(params) do
    params
    #receive the params and select the operation
    |> Operation.call(:withdraw)
    #execute a transaction
    |> run_transaction()
  end

  #--------------------- execute a transaction ---------------------
  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{withdraw: account}} -> {:ok, account}
    end
  end
end
