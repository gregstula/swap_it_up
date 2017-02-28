defmodule SwapItUp.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :have, :string, null: false
      add :want, :string, null: false
      add :content, :text, null: false
      add :votes, :integer, default: 0, null: false
      add :flagged, :boolean, default: false, null: false
      add :posted_on, :utc_datetime

      timestamps()
    end

  end
end
