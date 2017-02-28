defmodule SwapItUp.Auth do

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias SwapItUp.User
  alias SwapItUp.Repo

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
