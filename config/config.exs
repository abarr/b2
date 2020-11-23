# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :b2,
  ecto_repos: [B2.Repo]

# Configures the endpoint
config :b2, R2Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kGkKq4g8m0IfZKPylpw4bIcO3ncJEvNE6Eg1LdFd/Z0S6MdtO7dmCwDVGe1Jt/lB",
  render_errors: [view: R2Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: B2.PubSub,
  live_view: [signing_salt: "Hw9ykvYt"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :triplex, repo: B2.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
