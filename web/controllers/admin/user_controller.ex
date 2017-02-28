defmodule SwapItUp.Admin.UserController do

  use SwapItUp.Web, :admin_controller

  alias SwapItUp.User

  # Make sure we have a valid token in the :admin key of the session
  # We've already aliased Guardian.Plug.EnsureAuthenticated in our Phoenix.Web.admin_controller macro

  plug EnsureAuthenticated, handler: SwapItUp.Admin.Unauth, key: :admin

  def index(conn, _params, current_user, _claims) do
    users = Repo.all(User)
    render(conn, "index.html", users: users, current_user: current_user)
  end

  def delete(conn, %{"username" => username}) do
     user = Repo.get_by(User, username: username)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "#{username} deleted successfully.")
    |> redirect(to: page_path(conn, :index))
  end
end

