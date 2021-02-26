defmodule Rocketpay.Accounts.Operation do
  alias Ecto.Multi

  alias Rocketpay.Account

  def call(%{"id" => id, "value" => value}, operation) do
    operation_name = account_operation_name(operation) #get the operation name

    Multi.new()
    #get the account on the database
    |> Multi.run(operation_name, fn repo, _changes -> get_account(repo, id) end)
    #select the operation to be done on that account
    |> Multi.run(operation, fn repo, changes ->
      account = Map.get(changes, operation_name) #read the account that we got on the previous operation and executing the operation

      update_balance(repo, account, value, operation)
    end)
  end

  #--------------------- get the account ---------------------
  defp get_account(repo, id) do
    case repo.get(Account, id) do #repo.get(qual modulo tentamos fazer o get, o que estamos tentando ler)
      nil -> {:error, "Account not found"} #caso retorne nulo
      account -> {:ok, account} #caso receba uma conta
    end
  end

  #--------------------- update the balance ---------------------
  defp update_balance(repo, account, value, operation) do
    account
    |> operation(value, operation)
    |> update_account(repo, account)
  end

  defp operation(%Account{balance: balance}, value, operation) do
    value
    |> Decimal.cast()
    |> handle_cast(balance, operation)
  end

  defp handle_cast({:ok, value}, balance, :deposit), do: Decimal.add(balance, value) #caso ele receba um valor OK no cast
  defp handle_cast({:ok, value}, balance, :withdraw), do: Decimal.sub(balance, value) #caso ele receba um valor OK no cast
  defp handle_cast(:error, _balance, operation), do: {:error, "Invalid #{operation} value!"} #caso ele não receba um valor OK no cast

  defp update_account({:error, _reason} = error, _repo, _account), do: error

  defp update_account(value, repo, account) do
    params = %{balance: value}

    account
    |> Account.changeset(params)
    |> repo.update()
  end

  defp account_operation_name(operation) do
    "account_#{Atom.to_string(operation)}"
    |> String.to_atom()
  end

end
