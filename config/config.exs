# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tryblog,
  ecto_repos: [Tryblog.Repo]

# Configures the endpoint
config :tryblog, TryblogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gglIDWRct7XQVCCAUrrcXxfQXMlGu/qMvm8M0kHeulybgYl74E8+UB0HljB+y2wT",
  render_errors: [view: TryblogWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Tryblog.PubSub,
  live_view: [signing_salt: "nDOlLeNN"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# config :tryblog, Tryblog.Repo,
#  migration_primary_key: [type: :binary_id],
#  migration_foreign_key: [type: :binary_id]

config :tryblog, Tryblog.Guardian,
  issuer: "tryblog",
  secret_key: "orn3vOoo0DTejsk9X+wxGnYcZwUPuF7q0mJ6Z8w1bIAIcw9W71foi9b4ZKadAYex"

config :guardian, Guardian.DB,
  # Add your repository module
  repo: Tryblog.Repo,
  # default
  schema_name: "guardian_tokens",
  # store all token types if not set
  # token_types: ["refresh_token"],

  # default: 60 minutes
  sweep_interval: 60

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
