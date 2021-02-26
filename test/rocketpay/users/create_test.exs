defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when all params are valid, returns a user" do
      params = %{
        name: "Alessandro",
        password: "123456",
        nickname: "mainJinx",
        email: "mamaco@mamaco.com",
        age: 24
      }

      {:ok, %User{id: user_id}} = Create.call(params) #create the user
      user = Repo.get(User, user_id) #check if the user exists on the database

      assert %User{name: "Alessandro", age: 24, id: ^user_id} = user
    end

    test "when there are invalid params, returns a error" do
      params = %{
        name: "Alessandro",
        nickname: "mainJinx",
        email: "mamaco@mamaco.com",
        age: 12
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
