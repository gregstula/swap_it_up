defmodule SwapItUp.MarketController do
  use SwapItUp.Web, :controller

  alias SwapItUp.Market

  def index(conn, _params) do
    markets = Repo.all(Market)
    render(conn, "index.html", markets: markets)
  end

  def new(conn, _params) do
    changeset = Market.changeset(%Market{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"market" => market_params}) do
    changeset = Market.changeset(%Market{}, market_params)

    case Repo.insert(changeset) do
      {:ok, _market} ->
        conn
        |> put_flash(:info, "Market created successfully.")
        |> redirect(to: market_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"market_name" => market_name}) do
    market = Repo.get_by(Market, name: market_name)
    render(conn, "show.html", market: market)
  end

  def edit(conn, %{"market_name" => market_name}) do
    market = Repo.get_by(Market, name: market_name)
    changeset = Market.changeset(market)
    render(conn, "edit.html", market: market, changeset: changeset)
  end

  def update(conn, %{"market_name" => market_name, "market" => market_params}) do
    market = Repo.get_by(Market, name: market_name)
    changeset = Market.changeset(market, market_params)

    case Repo.update(changeset) do
      {:ok, market} ->
        conn
        |> put_flash(:info, "Market updated successfully.")
        |> redirect(to: market_path(conn, :show, market))
      {:error, changeset} ->
        render(conn, "edit.html", market: market, changeset: changeset)
    end
  end
end
