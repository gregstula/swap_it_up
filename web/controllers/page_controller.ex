defmodule SwapItUp.PageController do
  use SwapItUp.Web, :controller

  def index(conn, _params, _, _) do
    render conn, "index.html"
  end
end
