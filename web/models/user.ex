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
    |> start_new_score()
  end
  
  def password_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, [:password, :password_confirmation])
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 6, max: 100)
    #    |> validate_password_confirmation()
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

  defp start_new_score(changeset) do
  case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :score, 0)
      _ ->
        changeset
    end
  end
end

