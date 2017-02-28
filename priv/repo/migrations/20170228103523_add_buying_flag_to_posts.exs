defmodule SwapItUp.Repo.Migrations.AddBuyingFlagToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :buying, :boolean, default: true, null: false
    end
  end
end
