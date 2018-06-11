defmodule ZixWeb.Guardian.AuthErrorHandler do
  @moduledoc """
  Module to handle authentication error
  """
  use ZixWeb, :controller

  def auth_error(conn, {:unauthenticated, _reason}, _opts) do
    conn
    |> put_status(401)
    |> render(ZixWeb.ErrorView, "401.json")
  end

  def auth_error(conn, {:invalid_token, _reason}, _opts) do
    conn
    |> put_status(401)
    |> render(ZixWeb.ErrorView, "401.json")
  end

  def auth_error(conn, {_failure_type, _reason}, _opts) do
    conn
    |> put_status(500)
    |> render(ZixWeb.ErrorView, "500.json")
  end
end
