defmodule SwapItUp.UserController do

  use SwapItUp.Web, :controller
  alias SwapItUp.User

  plug EnsureAuthenticated, [key: :default, handler: SwapItUp.Unauth] when action in [:edit, :update]

  def new(conn, _params, _current_user, _claims) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}, _current_user, _claims) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"username" => username}, _current_user, _claims) do
    user = Repo.get_by(User, username: username)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"username" => username}, _current_user, _claims) do
    user = Repo.get_by(User, username)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"username" => username, "user" => user_params}, _current_user, _claims) do
    user = Repo.get_by(User, username: username)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end

