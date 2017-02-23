defmodule SwapItUp.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :password_hash, :string
      add :score, :integer

      timestamps()
    end
    create unique_index(:users, [:username])

  end
end
