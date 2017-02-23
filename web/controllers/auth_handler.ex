defmodule SwapItUp.AuthHandler do
  @moduledoc """
  """

  use SwapItUp.Web, :controller

  def unathenticated(conn, _params) do
    conn
    |> put_flash(:error, "You do not have permission to view that page")
    |> redirect(to: page_path(conn, :index))
  end
end
