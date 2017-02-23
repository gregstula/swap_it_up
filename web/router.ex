defmodule SwapItUp.Router do
  use SwapItUp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SwapItUp.AuthenticationController, repo: SwapItUp.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SwapItUp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/posts", PostController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", SwapItUp do
  #   pipe_through :api
  # end
end
