defmodule PhoenixAuthSandboxWeb.Router do
  use PhoenixAuthSandboxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixAuthSandboxWeb do
    pipe_through :api

    resources "/users", UserController, exept: [:new, :edit, :index]
  end
end
