defmodule SwapItUp.CurrentMarket do
  import Plug.Conn
  alias SwapItUp.Market

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
  end

end

