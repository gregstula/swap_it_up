defmodule SwapItUp.Admin.Unauth do
  use SwapItUp.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "administator access required")
    |> redirect(to: admin_session_path(conn, :new))
  end
end
