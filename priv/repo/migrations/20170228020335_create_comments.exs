defmodule SwapItUp.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text
      add :post_id, :integer

      timestamps()
    end
  end
end
