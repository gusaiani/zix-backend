defmodule ZixWeb.UserControllerTest do
  use ZixWeb.ConnCase

  import Zix.Factory

  alias Zix.{
    Repo,
    User
  }

  alias Comeonin.Bcrypt

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "login" do
    test "successful login", %{conn: conn} do
      user = insert(:user)

      conn =
        post(
          conn,
          user_path(conn, :login, %{"user" => %{"email" => user.email, "password" => "password"}})
        )

      assert response = json_response(conn, 201)
      assert response["user"]["token"]
    end

    test "fails when password is incorrect", %{conn: conn} do
      user = insert(:user)

      conn =
        post(
          conn,
          user_path(conn, :login, %{"user" => %{"email" => user.email, "password" => "wrongpass"}})
        )

      assert json_response(conn, 401)
    end

    test "fails when user doesn't exist", %{conn: conn} do
      conn =
        post(
          conn,
          user_path(conn, :login, %{
            "user" => %{"email" => "wrong@email.com", "password" => "password"}
          })
        )

      assert json_response(conn, 401)
    end
  end

  describe "register" do
    test "successful registration", %{conn: conn} do
      user_params = %{
        "email" => "validemail@emcasa.com",
        "password" => "validpassword",
      }

      conn = post(conn, user_path(conn, :register, %{"user" => user_params}))
      assert response = json_response(conn, 201)
      assert response["user"]["token"]
      assert user = Repo.get_by(User, email: "validemail@emcasa.com")
      assert user.confirmation_token
      refute user.confirmed
    end

    test "fails when password is invalid", %{conn: conn} do
      user_params = %{
        "name" => "mahname",
        "email" => "validemail@emcasa.com",
        "password" => ""
      }

      conn = post(conn, user_path(conn, :register, %{"user" => user_params}))
      assert response = json_response(conn, 422)
      refute response["user"]["token"]
    end

    test "fails when email is invalid", %{conn: conn} do
      user_params = %{
        "name" => "mahname",
        "email" => "invalidemail",
        "password" => "password"
      }

      conn = post(conn, user_path(conn, :register, %{"user" => user_params}))
      assert response = json_response(conn, 422)
      refute response["user"]["token"]
    end
  end
end

