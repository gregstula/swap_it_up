defmodule SwapItUp.Post do
  use SwapItUp.Web, :model

  schema "posts" do
    field :have, :string
    field :want, :string
    field :content, :string
    field :votes, :integer
    field :flagged, :boolean, default: false
    field :posted_on, Ecto.DateTime

    has_many :comments, SwapItUp.Comment
    belongs_to :user, SwapItUp.User
    belongs_to :market, SwapItUp.Market

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:have, :want, :content, :votes, :flagged, :posted_on])
    |> validate_required([:have, :want, :content, :votes, :flagged, :posted_on])
  end
end
