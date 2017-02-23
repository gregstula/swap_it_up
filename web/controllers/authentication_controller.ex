defmodule SwapItUp.AuthenticationController do
  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(SwapItUp.User, user_id)
    assign(conn, :current_user, user)
  end
end


