defmodule SwapItUp.SessionController do
  use SwapItUp.Web, :controller

  plug :scrub_params, "session" when action in [:create]
  plug EnsureAuthenticated, [handler: SwapItUp.Unauth] when action in [:delete]
  
  def new(conn, _params, _current_user, _claims) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => user, "password" => pw}}, _current_user, _claims) do
    case SwapItUp.Auth.verify_credentials(user, pw) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> Guardian.Plug.sign_in(user, :token, perms: %{
              default: Guardian.Permissions.max, 
            })

        |> redirect(to: page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username or password")
        |> render("new.html")
    end
  end

  def delete(conn, _params, _current_user, _claims) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "Successfully signed out")
    |> redirect(to: page_path(conn, :index))
  end
end
