defmodule SwapItUp.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use SwapItUp.Web, :controller
      use SwapItUp.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def admin_controller do
    quote do
      use Phoenix.Controller, namespace: SwapItUp.Admin
      use Guardian.Phoenix.Controller, key: :admin

      alias SwapItUp.Repo
      alias Guardian.Plug.EnsureAuthenticated
      alias Guardian.Plug.EnsurePermissions

      import Ecto.Schema
      import Ecto.Query, only: [from: 1, from: 2]

      import SwapItUp.Router.Helpers
      import SwapItUp.Auth
    end
  end

  def controller do
    quote do
      use Phoenix.Controller
      use Guardian.Phoenix.Controller

      alias SwapItUp.Repo
      import Ecto
      import Ecto.Query

      alias Guardian.Plug.EnsureAuthenticated
      alias Guardian.Plug.EnsurePermissions

      import SwapItUp.Router.Helpers
      import SwapItUp.Gettext
      import SwapItUp.Auth
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"#, pattern: "*/**"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import SwapItUp.Router.Helpers
      import SwapItUp.ErrorHelpers
      import SwapItUp.Gettext
      import SwapItUp.View.Helpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias SwapItUp.Repo
      import Ecto
      import Ecto.Query
      import SwapItUp.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
