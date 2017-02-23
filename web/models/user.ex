defmodule SwapItUp.User do
  use SwapItUp.Web, :model

  schema "users" do
    field :username, :string
    field :email, :string
    field :password_hash, :string
    field :score, :integer

    timestamps()

    # Virtual Fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email, :password_hash, :score])
    |> validate_required([:username, :email, :password_hash])
    |> validate_length(:username, min: 4, max: 20)
    |> unique_constraint(:username)
  end
end
