defmodule PhoenixAuthSandbox.FruitsTest do
  use PhoenixAuthSandbox.DataCase

  alias PhoenixAuthSandbox.Fruits

  describe "bananas" do
    alias PhoenixAuthSandbox.Fruits.Banana

    @valid_attrs %{color: "some color", name: "some name"}
    @update_attrs %{color: "some updated color", name: "some updated name"}
    @invalid_attrs %{color: nil, name: nil}

    test "list_bananas/0 returns all bananas" do
      user = user_fixture()
      %Banana{id: id} = banana_fixture(user)
      assert [%Banana{id: ^id}] = Fruits.list_bananas()
    end

    test "list_user_bananas/1 returns all bananas for given user" do
      user = user_fixture()
      %Banana{id: id} = banana_fixture(user)
      assert [%Banana{id: ^id}] = Fruits.list_user_bananas(user)
    end

    test "get_banana!/1 returns the banana with given id" do
      user = user_fixture()
      %Banana{id: id} = banana_fixture(user)
      assert %Banana{id: ^id} = Fruits.get_banana!(id)
    end

    test "get_user_banana!/2 returns the banana with given id for given user" do
      user = user_fixture()
      %Banana{id: id} = banana_fixture(user)
      assert %Banana{id: ^id} = Fruits.get_user_banana!(user, id)
    end

    test "create_banana/2 with valid data creates a banana" do
      user = user_fixture()
      assert {:ok, %Banana{} = banana} = Fruits.create_banana(user, @valid_attrs)
      assert banana.color == "some color"
      assert banana.name == "some name"
    end

    test "create_banana/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Fruits.create_banana(user, @invalid_attrs)
    end

    test "update_banana/2 with valid data updates the banana" do
      user = user_fixture()
      banana = banana_fixture(user)
      assert {:ok, %Banana{} = banana} = Fruits.update_banana(banana, @update_attrs)
      assert banana.color == "some updated color"
      assert banana.name == "some updated name"
    end

    test "update_banana/2 with invalid data returns error changeset" do
      user = user_fixture()
      %Banana{id: id} = banana = banana_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Fruits.update_banana(banana, @invalid_attrs)
      assert %Banana{id: ^id} = Fruits.get_banana!(id)
    end

    test "delete_banana/1 deletes the banana" do
      user = user_fixture()
      banana = banana_fixture(user)
      assert {:ok, %Banana{}} = Fruits.delete_banana(banana)
      assert_raise Ecto.NoResultsError, fn -> Fruits.get_banana!(banana.id) end
    end

    test "change_banana/1 returns a banana changeset" do
      user = user_fixture()
      banana = banana_fixture(user)
      assert %Ecto.Changeset{} = Fruits.change_banana(banana)
    end
  end
end
