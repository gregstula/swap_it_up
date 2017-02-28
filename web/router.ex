defmodule SwapItUp.Router do
  use SwapItUp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :admin_browser_auth do
    plug Guardian.Plug.VerifySession, key: :admin
    plug Guardian.Plug.LoadResource, key: :admin
  end

  pipeline :impersonation_browser_auth do
    plug Guardian.Plug.VerifySession, key: :admin
  end
  
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SwapItUp do
    pipe_through [:browser, :browser_auth] # Use the default browser stack

    get "/", PageController, :index

    get "/login", SessionController, :new
    delete "/logout", SessionController, :delete

    get "/users/signup", UserController, :new
    post "/users", UserController, :create 

    get "/markets", MarketController, :index
    get "/markets/new", MarketController, :new
    post "/markets", MarketController, :create

    resources "/posts", PostController
  end

  scope "/u", SwapItUp do
    pipe_through [:browser]

    get "/:username", UserController, :show
    get "/:username/edit", UserController, :edit
    patch "/:username", UserController, :update
    put "/:username", UserController, :update
  end

  scope "/m", SwapItUp do
    pipe_through [:browser]

    get "/:market_name", MarketController, :show
    get "/:market_name/edit", MarketController, :edit
    patch "/:market_name", MarketController, :update
    put "/:market_name", MarketController, :update
  end



  # This scope is inteded for admin users
  # Normal users can only go through the login page
  scope "/admin", SwapItUp.Admin, as: :admin do
    pipe_through [:browser, :admin_browser_auth, :impersonation_browser_auth]

    resources "/login", SessionController, only: [:new, :create]
    get "/logout", SessionController, :logout
    delete "/logout", SessionController, :logout, as: :logout
    post "/impersonate/:username", SessionController, :impersonate, as: :impersonate
    delete "/impersonate", SessionController, :stop_impersonating

    get "/users", UserController, :index
    delete "/users/:username", UserController, :delete
  end


  # Other scopes may use custom stacks.
  # scope "/api", SwapItUp do
  #   pipe_through :api
  # end
end
