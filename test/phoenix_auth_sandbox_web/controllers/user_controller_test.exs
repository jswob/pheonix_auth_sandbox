defmodule PhoenixAuthSandboxWeb.UserControllerTest do
  use PhoenixAuthSandboxWeb.ConnCase

  alias PhoenixAuthSandbox.Accounts.User

  @create_attrs %{
    name: "some name",
    username: "some username",
    password: "some password"
  }
  @update_attrs %{
    name: "some updated name",
    username: "updated username",
    password: "some updated password"
  }
  @invalid_attrs %{name: nil, password: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "requires user authentication on :update and :delete actions", %{conn: conn} do
    Enum.each(
      [
        put(conn, Routes.user_path(conn, :update, "123", %{})),
        delete(conn, Routes.user_path(conn, :delete, "123"))
      ],
      fn conn ->
        assert json_response(conn, 401)
        assert conn.halted
      end
    )
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name",
               "username" => "some username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup %{conn: conn}, do: setup_session(conn)

    test "updates user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      assert %{
               "id" => id,
               "name" => "some updated name",
               "username" => "updated username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup %{conn: conn}, do: setup_session(conn)

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp setup_session(conn) do
    user = user_fixture()
    conn = assign(conn, :current_user, user)

    {:ok, conn: conn, user: user}
  end
end
