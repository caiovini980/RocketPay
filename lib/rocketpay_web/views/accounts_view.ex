defmodule RocketpayWeb.AccountsView do
  alias Rocketpay.Account
  alias Rockerpay.Accounts.Transferences.Responses, as: TransferenceResponse

  def render("update.json", %{
      account: %Account{
        id: account_id,
        balance: balance
        }
      }) do
    %{
      message: "Balance successfully changed!",
      user: %{
        id: account_id,
        balance: balance
        }
      }
  end

  def render("transfer.json", %{
    transfer: %TransferenceResponse{
      to_account: to_account,
      from_account: from_account
      }
    }) do
    %{
      message: "Transference successfully done!",
      transference: %{
        from_account: %{
          id: from_account.id,
          balance: from_account.balance
        },
        to_account: %{
          id: to_account.id,
          balance: to_account.balance
        }
      }
    }
  end
end
