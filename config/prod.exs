use Mix.Config

config :zix, ZixWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: System.get_env("HOST"), port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE"),
  check_origin: false

# Do not print debug messages in production
config :logger, level: :info

config :zix, ZixWeb.Guardian,
  allowed_algos: ["ES512"],
  secret_key: %{
    "alg" => "ES512",
    "crv" => "P-521",
    "d" => System.get_env("GUARDIAN_D"),
    "kty" => "EC",
    "use" => "sig",
    "x" => System.get_env("GUARDIAN_X"),
    "y" => System.get_env("GUARDIAN_Y")
  }


config :zix, Zix.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "18"),
  ssl: true
