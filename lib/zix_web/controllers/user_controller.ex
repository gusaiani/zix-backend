defmodule ZixWeb.UserController do
  use ZixWeb, :controller
  use ZixWeb.GuardedController

  alias Zix.Accounts.{
    Auth,
    Users
  }

  @emails Application.get_env(:re, :emails, ZixWeb.Notifications.Emails)

  action_fallback(ZixWeb.FallbackController)

  plug(
    Guardian.Plug.EnsureAuthenticated
    when action in [:change_email, :edit_password]
  )

  def login(conn, %{"user" => %{"email" => email, "password" => password}}, _user) do
    with {:ok, user} <- Auth.find_user(email),
         :ok <- Auth.check_password(password, user),
         {:ok, jwt, _full_claims} <- ZixWeb.Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render(ZixWeb.UserView, "login.json", jwt: jwt, user: user)
    end
  end

  def register(conn, %{"user" => params}, _user) do
    with {:ok, user} <- Users.create(params),
         {:ok, jwt, _full_claims} <- ZixWeb.Guardian.encode_and_sign(user) do
      @emails.confirm(user)

      @emails.user_registered(user)

      conn
      |> put_status(:created)
      |> render(ZixWeb.UserView, "login.json", jwt: jwt, user: user)
    end
  end

  def confirm(conn, %{"user" => %{"token" => token}}, _user) do
    with {:ok, user} <- Users.confirm(token),
         {:ok, jwt, _full_claims} <- ZixWeb.Guardian.encode_and_sign(user) do
      @emails.welcome(user)

      render(conn, ZixWeb.UserView, "login.json", jwt: jwt, user: user)
    end
  end

  def reset_password(conn, %{"user" => %{"email" => email}}, _user) do
    with {:ok, user} <- Users.get_by_email(email),
         {:ok, user} <- Users.reset_password(user) do
      @emails.reset_password(user)

      render(conn, ZixWeb.UserView, "show.json", user: user)
    end
  end

  def redefine_password(
        conn,
        %{"user" => %{"reset_token" => token, "password" => password}},
        _user
      ) do
    with {:ok, user} <- Users.get_by_reset_token(token),
         {:ok, user} <- Users.redefine_password(user, password) do
      render(conn, ZixWeb.UserView, "show.json", user: user)
    end
  end

  def edit_password(
        conn,
        %{
          "user" => %{"current_password" => current_password, "new_password" => new_password}
        },
        %{id: id}
      ) do
    with {:ok, user} <- Users.get(id),
         :ok <- Auth.check_password(current_password, user),
         {:ok, user} <- Users.edit_password(user, new_password) do
      render(conn, ZixWeb.UserView, "show.json", user: user)
    end
  end

  def change_email(conn, %{"user" => %{"email" => new_email}}, %{id: id}) do
    with {:ok, user} <- Users.get(id),
         {:ok, user} <- Users.change_email(user, new_email) do
      @emails.change_email(user)

      render(conn, ZixWeb.UserView, "show.json", user: user)
    end
  end
end
