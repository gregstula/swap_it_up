# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :swap_it_up,
  ecto_repos: [SwapItUp.Repo]

# Configures the endpoint
config :swap_it_up, SwapItUp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "j/2WGaloxnIEm+GtdL3Hc2nGDicwzZz7/weYRHrix5Xi6jGr4NXFF95+ZK5oUcCF",
  render_errors: [view: SwapItUp.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SwapItUp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "SwapItUp",
  ttl: {3, :days},
  verify_issuer: true,
  secret_key: "Sj/T5UzdMWl4z2yADwOwfZ3xzb9cltvpf5t24bAiRWyZwOgFTlVqoG2WMcqF+5nP",
  serializer: SwapItUp.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
