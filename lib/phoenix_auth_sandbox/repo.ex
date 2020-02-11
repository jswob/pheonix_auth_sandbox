defmodule PhoenixAuthSandbox.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_auth_sandbox,
    adapter: Ecto.Adapters.Postgres
end
