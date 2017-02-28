defmodule SwapItUp.Repo.Migrations.AddMarketIdToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :market_id, references(:markets)
    end
  end
end
