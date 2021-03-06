# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :zix,
  ecto_repos: [Zix.Repo]

# Configures the endpoint
config :zix, ZixWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lA+f9OpWeX78ElQ+glazwywfnWeyXiah1D7NEP2KuW1qPXmsTQjavNvbpBQV4XNu",
  render_errors: [view: ZixWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Zix.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :zix, ZixWeb.Guardian,
  allowed_algos: ["HS256"],
  issuer: "Zix",
  ttl: {30, :days},
  allowed_drift: 2000,
  # optional
  verify_issuer: true,
  secret_key: "MDLMflIpKod5YCnkdiY7C4E3ki2rgcAAMwfBl0+vyC5uqJNgoibfQmAh7J3uZWVK",
  serializer: Zix.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
