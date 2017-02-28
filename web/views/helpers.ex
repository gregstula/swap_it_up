defmodule SwapItUp.View.Helpers do

  # Admin
  def admin_logged_in?(conn), do: Guardian.Plug.authenticated?(conn, :admin)
  def current_admin_user(conn), do: Guardian.Plug.current_resource(conn, :admin)

  # Default
  def logged_in?(conn), do: Guardian.Plug.authenticated?(conn, :default)
  def current_user(conn), do: Guardian.Plug.current_resource(conn, :default)
end
