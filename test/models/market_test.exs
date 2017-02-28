defmodule SwapItUp.MarketTest do
  use SwapItUp.ModelCase

  alias SwapItUp.Market

  @valid_attrs %{date_created: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Market.changeset(%Market{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Market.changeset(%Market{}, @invalid_attrs)
    refute changeset.valid?
  end
end
