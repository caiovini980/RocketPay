defmodule RocketpayWeb.UsersController do
  use RocketpayWeb, :controller

  alias Rocketpay.User

  action_fallback RocketpayWeb.FallbackController

  def create(connection, params) do
    with {:ok, %User{} = user} <- Rocketpay.create_user(params) do #if error, return this error for who called this fuction
      connection
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end

end
