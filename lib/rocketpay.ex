defmodule Rocketpay do
  alias Rocketpay.Users.Create, as: UserCreate
  alias Rocketpay.Accounts.Deposit
  alias Rocketpay.Accounts.Withdraw
  alias Rocketpay.Accounts.Transfer

  defdelegate create_user(params), to: UserCreate, as: :call

  defdelegate deposit(params), to: Deposit, as: :call
  defdelegate withdraw(params), to: Withdraw, as: :call
  defdelegate transfer(params), to: Transfer, as: :call

end
