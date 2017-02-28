defmodule SwapItUp.MarketController do
  use SwapItUp.Web, :controller

  alias SwapItUp.Market

  def index(conn, _params, _current_user, _claims) do
    markets = Repo.all(Market)
    render(conn, "index.html", markets: markets)
  end

  def new(conn, _params, _current_user, _claims) do
    changeset = Market.changeset(%Market{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"market" => market_params}, _current_user, _claims ) do
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

  def show(conn, %{"name" => market_name}, _current_user, _claims) do
    market = Repo.get_by(Market, name: market_name)
    market_posts = Repo.all from m in Market,
      join: p in assoc(m, :posts),
      join: c in assoc(p, :comments),
      where: m.name == ^market_name,
      select: p
    render(conn, "show.html", market: market, posts: market_posts)
  end

  def edit(conn, %{"name" => market_name}, _current_user, _claims) do
    market = Repo.get_by(Market, name: market_name)
    changeset = Market.changeset(market)
    render(conn, "edit.html", market: market, changeset: changeset)
  end

  def update(conn, %{"name" => market_name, "market" => market_params}, _current_user, _claims) do
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
