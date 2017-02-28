defmodule SwapItUp.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :have, :string
      add :want, :string
      add :content, :text
      add :votes, :integer
      add :flagged, :boolean, default: false, null: false
      add :posted_on, :utc_datetime

      timestamps()
    end

  end
end
