defmodule SwapItUp.Repo.Migrations.AddDatetimesToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :date_created, :utc_datetime
      add :last_online, :utc_datetime
    end
  end
end
