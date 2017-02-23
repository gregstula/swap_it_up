defmodule SwapItUp.Router do
  use SwapItUp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: SwapItUp.AuthHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/admin", SwapItUp.Admin do
    pipe_through [:browser, :browser_session, :auth]
  end

  scope "/", SwapItUp do
    pipe_through [:browser, :browser_session] # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/posts", PostController
  end

  # Other scopes may use custom stacks.
  # scope "/api", SwapItUp do
  #   pipe_through :api
  # end
end
