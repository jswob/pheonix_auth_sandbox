defmodule PhoenixAuthSandboxWeb.Router do
  use PhoenixAuthSandboxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug PhoenixAuthSandboxWeb.Auth
  end

  scope "/", PhoenixAuthSandboxWeb do
    pipe_through :api

    resources "/users", UserController, exept: [:new, :edit, :index]
    post "/sessions", SessionController, :create
    delete "/sessions", SessionController, :delete
  end

  scope "/", PhoenixAuthSandboxWeb do
    pipe_through [:api, :ensure_authenticated]

    resources "/bananas", BananaController, exept: [:new, :edit]
  end
end
