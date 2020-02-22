defmodule PhoenixAuthSandboxWeb.SessionControllerTest do
  use PhoenixAuthSandboxWeb.ConnCase, async: true

  @bad_params %{
    username: "wrong username",
    password: "wrong password"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "requires user authentication on :delete action", %{conn: conn} do
    conn = delete(conn, Routes.user_path(conn, :delete, "123"))

    assert json_response(conn, 401)
    assert conn.halted
  end

  describe "create session" do
    setup [:create_user]

    test "creates session with valid user data if params correct", %{
      conn: conn,
      user: %{id: id, password_hash: pwh} = user
    } do
      conn =
        post(conn, Routes.session_path(conn, :create),
          session: %{username: user.username, password: "some password"}
        )

      assert id == get_session(conn, :user_id)

      assert %{
               "id" => ^id,
               "name" => "some name",
               "password_hash" => ^pwh
             } = json_response(conn, 200)
    end

    test "returns error code and message if params are bad", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @bad_params)

      assert %{"errors" => %{"detail" => "Bad username or password"}} = json_response(conn, 422)
    end
  end

  describe "delete session" do
    setup %{conn: conn} do
      user = user_fixture()
      conn = assign(conn, :current_user, user)

      {:ok, conn: conn, user: user}
    end

    test "deletes current session", %{conn: conn} do
      conn = delete(conn, Routes.session_path(conn, :delete))

      assert nil == conn.assigns[:current_user]
      assert nil == get_session(conn, :user_id)
    end
  end

  defp create_user(_) do
    {:ok, user: user_fixture()}
  end
end
