defmodule PhoenixAuthSandbox.TestHelpers do
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{name: "some name", username: "some username", password: "some password"})
      |> PhoenixAuthSandbox.Accounts.register_user()

    user
  end
end
