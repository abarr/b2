use Mix.Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :b2, R2Web.Endpoint,
  server: true,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  url: [host: "mineit.com.au", port: 80],
  check_origin: [
    "https://mineit.com.au",
    "https://www.mineit.com.au"
  ],
  secret_key_base: System.get_env("KEY_BASE"),
  live_view: [signing_salt: System.get_env("SIGNING_SALT")]

# Do not print debug messages in production
config :logger, level: :debug
# config :logger, :console, format: "[$level] $message\n"


config :b2, B2.Repo,
  username: "b2",
  password: System.get_env("PG_PASS"),
  database: "r2_prod",
  hostname: "127.0.0.1",
  pool_size: 10

config :b2, B2.Accounts.Mailer,
  adapter: Swoosh.Adapters.Mailgun,
  api_key: System.get_env("MAILGUN_KEY"),
  domain: System.get_env("DOMAIN"),
  from_email: System.get_env("EMAIL")

config :b2,
  test_account_pw: System.get_env("TEST_ACCOUNT_PW"),
  admin_account_pw: System.get_env("ADMIN_ACCOUNT_PW")
