defmodule SwapItUp.Post do
  use SwapItUp.Web, :model

  schema "posts" do
    field :have, :string
    field :want, :string
    field :content, :string
    field :votes, :integer, default: 0
    field :buying, :boolean, default: true
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
    |> cast(params, [:have, :want, :content])
    |> validate_required([:have, :want, :content,])
  end
end
