defmodule SwapItUp.Admin.UserController do

  use SwapItUp.Web, :admin_controller

  alias SwapItUp.User

  # Make sure we have a valid token in the :admin key of the session
  # We've already aliased Guardian.Plug.EnsureAuthenticated in our Phoenix.Web.admin_controller macro

  plug EnsureAuthenticated, handler: __MODULE__, key: :admin

  def index(conn, _params, current_user, _claims) do
    users = Repo.all(User)
    render(conn, "index.html", users: users, current_user: current_user)
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "administator access required")
    |> redirect(to: admin_session_path(conn, :new))
  end
end

