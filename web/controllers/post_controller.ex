defmodule SwapItUp.PostController do
  use SwapItUp.Web, :controller

  alias SwapItUp.Post
  alias SwapItUp.Market

  plug :scrub_params, "post" when action in [:create]

  plug EnsureAuthenticated, [key: :default, handler: SwapItUp.Unauth] when action in [:new, :create, :edit, :update, :delete]

  def new(conn, %{"market_name" => market_name}, current_user, _claims) do
    market = Repo.get_by(Market, name: market_name)
    changeset = current_user |> build_assoc(:post_history) |> Post.changeset()
    render(conn, "new.html", changeset: changeset, market: market)
  end

  def create(conn, %{"post" => post_params, "market_name" => market_name}, _current_user, _claims) do
    market = Repo.get_by(Market, name: market_name)
    changeset = market |> build_assoc(:posts) |> Post.changeset(post_params)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: market_path(conn, :show, market.name))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id, "market_name" => market_name}, _current_user, _claims) do
    market = Repo.get_by(Market, name: market_name)
    post = Repo.get!(Post, id)
    render(conn, "show.html", post: post, market: market)
  end

  def edit(conn, %{"id" => id, "market_name" => market_name}, _current_user, _claims) do
    market = Repo.get_by(Market, name: market_name)
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset, market: market)
  end

  def update(conn, %{"id" => id, "post" => post_params, "market_name" => market_name}, _current_user, _claims) do
    market = Repo.get_by(Market, name: market_name)
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: market_post_path(conn, :show, market.name, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset, market: market)
    end
  end

  def delete(conn, %{"id" => id, "market_name" => market_name}, _current_user, _claims) do
    market = Repo.get_by(Market, name: market_name)
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: market_path(conn, :show, market))
  end
end
