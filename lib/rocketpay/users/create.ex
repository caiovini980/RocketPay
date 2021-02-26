defmodule Rocketpay.Users.Create do
  alias Ecto.Multi
  alias Rocketpay.{Account, Repo, User}

  def call(params) do
    Multi.new() #creates an empty Ecto.Multi struct
    # add an user to the Multi struct
    |> Multi.insert(:create_user, User.changeset(params))
    # add an account struct to that user
    |> Multi.run(:create_account, fn repo, %{create_user: user} ->
      insert_account(repo, user) #insert a struct to another struct on the database. In this case, insert the struct account (coming from the Ecto.Multi) on the User's struct
    end)
    |> Multi.run(:preload_data, fn repo, %{create_user: user} ->
      preload_data(repo, user)
    end)
    |> run_transaction()
  end

  # --------------------- create an account for that user ---------------------
  defp insert_account(repo, user) do
    user.id #get the user's ID
    |> account_changeset() # add a balance of "0.00" for this recently created user
    |> repo.insert() # add the user, with an account, to the database
  end

  defp account_changeset(user_id) do
    params = %{user_id: user_id, balance: "0.00"}

    Account.changeset(params)
  end

  #get the account information about that user
  defp preload_data(repo, user) do
    {:ok, repo.preload(user, :account)}
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{preload_data: user}} -> {:ok, user}
    end
  end
end
