defmodule SwapItUp.UserTest do
  use SwapItUp.ModelCase

  alias SwapItUp.User

  @valid_attrs %{email: "some content", password: "some content", password_hash: "some content", score: 42, username: "some content"}
  @invalid_attrs %{}

  #  test "changeset with valid attributes" do
  # changeset = User.changeset(%User{}, @valid_attrs)
  # assert changeset.valid?
  #end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
