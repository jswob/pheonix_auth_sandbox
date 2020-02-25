defmodule PhoenixAuthSandboxWeb.BananaControllerTest do
  use PhoenixAuthSandboxWeb.ConnCase

  alias PhoenixAuthSandbox.Fruits.Banana

  @create_attrs %{
    color: "some color",
    name: "some name"
  }
  @update_attrs %{
    color: "some updated color",
    name: "some updated name"
  }
  @invalid_attrs %{color: nil, name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, Routes.banana_path(conn, :index)),
        post(conn, Routes.banana_path(conn, :create, %{})),
        put(conn, Routes.banana_path(conn, :update, 123, %{})),
        get(conn, Routes.banana_path(conn, :show, 123)),
        delete(conn, Routes.banana_path(conn, :delete, 123))
      ],
      fn conn ->
        assert json_response(conn, 401)
        assert conn.halted
      end
    )
  end

  test "authorizes actions against access by other users", %{conn: conn} do
    owner = user_fixture()
    banana = banana_fixture(owner)
    not_owner = user_fixture(%{username: "sneaky"})
    conn = assign(conn, :current_user, not_owner)

    assert_error_sent :not_found, fn ->
      put(conn, Routes.banana_path(conn, :update, banana), banana: @update_attrs)
    end

    assert_error_sent :not_found, fn ->
      get(conn, Routes.banana_path(conn, :show, banana))
    end

    assert_error_sent :not_found, fn ->
      delete(conn, Routes.banana_path(conn, :delete, banana))
    end
  end

  describe "index" do
    setup [:setup_session]

    test "lists all bananas", %{conn: conn} do
      list_conn = get(conn, Routes.banana_path(conn, :index))
      assert json_response(list_conn, 200)["data"] == []
    end
  end

  describe "create banana" do
    setup [:setup_session]

    test "renders banana when data is valid", %{conn: conn} do
      create_conn = post(conn, Routes.banana_path(conn, :create), banana: @create_attrs)
      assert %{"id" => id} = json_response(create_conn, 201)["data"]

      get_conn = get(conn, Routes.banana_path(conn, :show, id))

      assert %{
               "id" => id,
               "color" => "some color",
               "name" => "some name"
             } = json_response(get_conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      create_conn = post(conn, Routes.banana_path(conn, :create), banana: @invalid_attrs)
      assert json_response(create_conn, 422)["errors"] != %{}
    end
  end

  describe "update banana" do
    setup [:setup_session, :create_banana]

    test "renders banana when data is valid", %{conn: conn, banana: %Banana{id: id} = banana} do
      update_conn = put(conn, Routes.banana_path(conn, :update, banana), banana: @update_attrs)
      assert %{"id" => ^id} = json_response(update_conn, 200)["data"]

      get_conn = get(conn, Routes.banana_path(conn, :show, id))

      assert %{
               "id" => id,
               "color" => "some updated color",
               "name" => "some updated name"
             } = json_response(get_conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, banana: banana} do
      update_conn = put(conn, Routes.banana_path(conn, :update, banana), banana: @invalid_attrs)
      assert json_response(update_conn, 422)["errors"] != %{}
    end
  end

  describe "delete banana" do
    setup [:setup_session, :create_banana]

    test "deletes chosen banana", %{conn: conn, banana: banana} do
      delete_conn = delete(conn, Routes.banana_path(conn, :delete, banana))
      assert response(delete_conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.banana_path(conn, :show, banana))
      end
    end
  end

  defp create_banana(%{conn: conn}) do
    banana = banana_fixture(conn.assigns[:current_user])

    {:ok, conn: conn, banana: banana}
  end
end
