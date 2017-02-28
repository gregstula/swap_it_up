defmodule SwapItUp.Unauth do
  use SwapItUp.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You need to be logged in to do that")
    |> redirect(to: session_path(conn, :new))
  end
end
