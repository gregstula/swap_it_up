defmodule SwapItUp.Repo.Migrations.CreateMarket do
  use Ecto.Migration

  def change do
    create table(:markets) do
      add :name, :string
      add :date_created, :datetime

      timestamps()
    end
    create unique_index(:markets, [:name])

  end
end
