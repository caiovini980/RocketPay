defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  alias Rocketpay.Account
  alias Rocketpay.User
  alias RocketpayWeb.UsersView

  test "renders create.json" do
    params = %{
      name: "Alessandro",
      password: "123456",
      nickname: "mainJinx",
      email: "mamaco@mamaco.com",
      age: 24
    }

    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} = Rocketpay.create_user(params)

    response = render(UsersView, "create.json", user: user)

    expected_response = %{
      message: "User created",
      user: %{
        account: %{
          balance: Decimal.new("0.00"),
          id: account_id
        },
        id: user_id,
        name: "Alessandro",
        nickname: "mainJinx"
      }
    }

    assert expected_response == response
  end

end
