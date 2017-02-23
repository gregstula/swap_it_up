defmodule SwapItUp.SessionController do
  use SwapItUp.Web, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias SwapItUp.User

  def new(conn, _) do
    render conn, "new.html"
  end
  
  def create(conn, %{"session" => %{"username" => user, "password" => pw}}) do
    case verify_credentials(user, pw) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "Successfully signed out")
    |> redirect(to: page_path(conn, :index))
  end

  def verify_credentials(username, password) when is_binary(username) and is_binary(password) do
    with {:ok, user} <- find_by_username(username),
      do: verify_password(password, user)
  end

  defp find_by_username(username) when is_binary(username) do
    case Repo.get_by(User, username: username) do
      nil ->
        dummy_checkpw()
        {:error, "User with username: '#{username}' not found"}
      user ->
        {:ok, user}
    end
  end

  defp verify_password(password, %User{} = user) when is_binary(password) do
    if checkpw(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end
end
