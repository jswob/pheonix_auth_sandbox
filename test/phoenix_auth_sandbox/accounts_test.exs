defmodule PhoenixAuthSandbox.AccountsTest do
  use PhoenixAuthSandbox.DataCase

  alias PhoenixAuthSandbox.Accounts

  describe "users" do
    alias PhoenixAuthSandbox.Accounts.User

    @valid_attrs %{name: "some name", username: "some username", password: "some password"}
    @update_attrs %{
      name: "some updated name",
      username: "updated username",
      password: "some updated password"
    }
    @invalid_attrs %{name: nil, username: nil, password: nil}

    test "list_users/0 returns all users" do
      %User{id: id} = user_fixture()
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "get_user!/1 returns the user with given id" do
      %User{id: id} = user_fixture()
      assert %User{id: ^id} = Accounts.get_user!(id)
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.name == "some name"
      assert user.username == "some username"
      assert user.password == nil
    end

    test "create_user/1 with to long username returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_user(
                 Enum.into(%{username: String.duplicate("a", 21)}, @valid_attrs)
               )
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)

      assert user.name == "some updated name"
      assert user.username == "updated username"
      assert user.password == "some updated password"
    end

    test "update_user/2 updates user correctly if password was not changed" do
      user = user_fixture()

      assert {:ok, %User{} = user} =
               Accounts.update_user(user, %{
                 name: "some updated name",
                 username: "updated username"
               })

      assert user.name == "some updated name"
      assert user.username == "updated username"
      assert user.password == nil
    end

    test "update_user/2 with invalid data returns error changeset" do
      %User{id: id} = user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert %User{id: ^id} = Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "change_registration/2 returns changed user changeset" do
      user = user_fixture()

      assert %Ecto.Changeset{
               changes: %{
                 name: "some updated name",
                 username: "updated username",
                 password: "some updated password"
               }
             } = Accounts.change_registration(user, @update_attrs)
    end

    test "check_users_pass/2 returns {:ok, %User{}} if params are correct" do
      %User{id: id} = user = user_fixture()

      assert {:ok, %User{id: ^id}} = Accounts.check_users_pass(user.username, "some password")
    end

    test "check_users_pass/2 returns {:error, _reason} if data are bad" do
      user = user_fixture()

      assert {:error, :unauthorized} = Accounts.check_users_pass(user.username, "bad password")

      assert {:error, :not_found} = Accounts.check_users_pass("bad username", "some password")
    end
  end
end
