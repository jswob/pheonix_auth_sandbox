use Mix.Config

# Configure your database
config :phoenix_auth_sandbox, PhoenixAuthSandbox.Repo,
  username: "postgres",
  password: "postgres",
  database: "phoenix_auth_sandbox_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_auth_sandbox, PhoenixAuthSandboxWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
