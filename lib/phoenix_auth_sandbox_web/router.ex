defmodule PhoenixAuthSandboxWeb.Router do
  use PhoenixAuthSandboxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhoenixAuthSandboxWeb do
    pipe_through :api
  end
end
