defmodule PhoenixAuthSandbox.TestHelpers do
  import Plug.Conn

  alias PhoenixAuthSandbox.Accounts

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "some name",
        username: "user#{System.unique_integer([:positive])}",
        password: "some password"
      })
      |> Accounts.register_user()

    Accounts.get_user!(user.id)
  end

  def banana_fixture(user, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "some name",
        color: "some color"
      })

    {:ok, banana} = PhoenixAuthSandbox.Fruits.create_banana(user, attrs)

    banana
  end

  def setup_session(%{conn: conn}) do
    user = user_fixture()
    conn = assign(conn, :current_user, user)

    {:ok, conn: conn, user: user}
  end
end
