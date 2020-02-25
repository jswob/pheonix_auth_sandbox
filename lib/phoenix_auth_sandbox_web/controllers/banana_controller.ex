defmodule PhoenixAuthSandboxWeb.BananaController do
  use PhoenixAuthSandboxWeb, :controller

  import Ecto.Changeset

  alias PhoenixAuthSandbox.Fruits
  alias PhoenixAuthSandbox.Fruits.Banana

  action_fallback PhoenixAuthSandboxWeb.FallbackController

  def index(conn, _params) do
    bananas = Fruits.list_user_bananas(conn.assigns[:current_user])
    render(conn, "index.json", bananas: bananas)
  end

  def create(conn, %{"banana" => banana_params}) do
    with {:ok, %Banana{} = banana} <-
           Fruits.create_banana(conn.assigns[:current_user], banana_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.banana_path(conn, :show, banana))
      |> render("show.json", banana: banana)
    end
  end

  def show(conn, %{"id" => id}) do
    try do
      Fruits.get_user_banana!(conn.assigns[:current_user], id)
    catch
      _ ->
        conn
        |> put_status(404)
        |> put_view(PhoenixAuthSandboxWeb.ErrorView)
        |> render("error.json", message: "Banana with that id was not found")
    else
      banana ->
        render(conn, "show.json", banana: banana)
    end
  end

  def update(conn, %{"id" => id, "banana" => banana_params}) do
    banana = Fruits.get_user_banana!(conn.assigns[:current_user], id)

    case Fruits.update_banana(banana, banana_params) do
      {:ok, banana} ->
        render(conn, "show.json", banana: banana)

      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_status(422)
        |> put_view(PhoenixAuthSandboxWeb.ErrorView)
        |> render("error.json", message: "Color and name should be include in banana attributes")

      {:error, _reason} ->
        conn
        |> put_status(404)
        |> put_view(PhoenixAuthSandboxWeb.ErrorView)
        |> render("error.json", message: "Banana with that id was not found")
    end
  end

  def delete(conn, %{"id" => id}) do
    banana = Fruits.get_user_banana!(conn.assigns[:current_user], id)

    case Fruits.delete_banana(banana) do
      {:ok, banana} ->
        conn
        |> put_status(204)
        |> render("show.json", banana: banana)

      {:error, _reason} ->
        conn
        |> put_status(404)
        |> put_view(PhoenixAuthSandboxWeb.ErrorView)
        |> render("error.json", message: "Banana with that id was not found")
    end
  end
end
