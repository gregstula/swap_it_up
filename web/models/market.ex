defmodule SwapItUp.Market do
  use SwapItUp.Web, :model

  schema "markets" do
    field :name, :string
    field :date_created, Ecto.DateTime

    has_many :posts, SwapItUp.Post
    has_many :subscribers, SwapItUp.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :date_created])
    |> validate_required([:name, :date_created])
    |> unique_constraint(:name)
  end
end
