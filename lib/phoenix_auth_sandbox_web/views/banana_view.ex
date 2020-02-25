defmodule PhoenixAuthSandboxWeb.BananaView do
  use PhoenixAuthSandboxWeb, :view
  alias PhoenixAuthSandboxWeb.BananaView

  def render("index.json", %{bananas: bananas}) do
    %{data: render_many(bananas, BananaView, "banana.json")}
  end

  def render("show.json", %{banana: banana}) do
    %{data: render_one(banana, BananaView, "banana.json")}
  end

  def render("banana.json", %{banana: banana}) do
    %{id: banana.id, name: banana.name, color: banana.color}
  end
end
