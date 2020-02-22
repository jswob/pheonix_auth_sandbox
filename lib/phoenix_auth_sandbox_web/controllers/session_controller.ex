defmodule PhoenixAuthSandboxWeb.SessionController do
  use PhoenixAuthSandboxWeb, :controller

  alias PhoenixAuthSandboxWeb.Auth

  action_fallback PhoenixAuthSandboxWeb.FallbackController
  plug :ensure_authenticated when action in [:delete]

  def create(conn, %{"session" => %{"username" => username, "password" => pass}}) do
    case PhoenixAuthSandbox.Accounts.check_users_pass(username, pass) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> put_status(200)
        |> put_view(PhoenixAuthSandboxWeb.UserView)
        |> render("user.json", %{user: user})

      {:error, _reason} ->
        conn
        |> put_status(422)
        |> put_view(PhoenixAuthSandboxWeb.ErrorView)
        |> render("error.json", message: "Bad username or password")
        |> halt()
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.logout()
    |> put_status(200)
  end
end
