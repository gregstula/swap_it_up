defmodule SwapItUp.User do
  use SwapItUp.Web, :model

  schema "users" do
    field :username, :string
    field :email, :string
    field :password_hash, :string
    field :role, :string
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
    |> cast(params, [:username, :email, :score])
    |> validate_required([:username, :email])
    |> validate_length(:username, min: 4, max: 20)
    |> validate_format(:email, ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> password_changeset(params)
    |> initialize_new_user()
  end
  
  def password_changeset(model, params) do
    model |> changeset(params) |> cast(params, [:password, :password_confirmation]) |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password, message: "does not match")
    |> put_pw_hash()
  end 

  defp put_pw_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pw}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pw))
      _ ->
        changeset
    end
  end

  defp initialize_new_user(changeset) do
  case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :score, 0) 
        |> put_change(:role, "normal") 
        |> validate_required([:score, :role])
      _ ->
        changeset
    end
  end
end

