defmodule SwapItUp.Admin.SessionController do

  @moduledoc """
  Provides login and logout logic for the admin part of the site. We keep the logins seperate rather than use
  permissions for this because keeping the tokens in seperate locations allows us to more easily manage different
  requirements between the normal site and the admin site.
  """

  use SwapItUp.Web, :admin_controller
  alias SwapItUp.User

  # Manke sure we have a valid token in the :admin key of the session
  # We've aliased Guardian.Plug.EnsureAuthentication in out admin_controller macro
  plug EnsureAuthenticated, [key: :admin, handler: SwapItUp.Admin.Unauth] 
    when action in [:delete, :impersonate, :stop_impersonating] 

  plug :scrub_params, "admin_session" when action in [:create]

  def new(conn, _params, current_user, _claims) do
    render conn, "new.html", current_user: current_user
  end

  def create(conn, %{"admin_session" => %{"username" => username, "password" => pw}}, _current_user, _claims) do
    case verify_credentials(username, pw) do
      {:ok, user} ->
        if user.is_admin do
          conn
          |> put_flash(:info, "Signed in as admin #{user.username}")
          |> Guardian.Plug.sign_in(user, :token, key: :admin, perms: %{
              default: Guardian.Permissions.max, 
              admin: [:dashboard, :reconcile]
            })
          |> redirect(to: admin_user_path(conn, :index))
        else
          conn
          |> put_flash(:error, "Unauthorized")
          |> redirect(to: page_path(conn, :index))
        end
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username or password")
        |> render("new.html")
    end
  end

  def delete(conn, _params, _current_user, _claims ) do
    conn
    |> Guardian.Plug.sign_out(:admin)
    |> put_flash(:info, "Admin signed out")
    |> redirect(to: "/")
  end

  def impersonate(conn, %{"user_id" => id}, _current_user, _claims) do
    admin = Guardian.Plug.current_resource(conn, :admin)
    user = Repo.get(User, id)
    conn
    |> Guardian.Plug.sign_out(:default)
    |> Guardian.Plug.sign_in(user, :token, perms: %{ default: Guardian.Permissions.max }, imp: admin.id)
    |> redirect(to: "/")
  end


  def stop_impersonating(conn, _params, _current_user, _claims ) do
    conn
    |> Guardian.Plug.sign_out(:default)
    |> redirect(to: admin_user_path(conn, :index))
  end

end


