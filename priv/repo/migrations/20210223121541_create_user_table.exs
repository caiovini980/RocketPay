defmodule Rocketpay.Repo.Migrations.CreateUserTable do
  use Ecto.Migration

  def change do
    create table :users do
      add :name, :string
      add :age, :integer
      add :email, :string
      add :password_hash, :string
      add :nickname, :string

      timestamps()
    end

    #can`t have users with the same email and with the same nickname
    create unique_index(:users, [:email])
    create unique_index(:users, [:nickname])
  end
end
