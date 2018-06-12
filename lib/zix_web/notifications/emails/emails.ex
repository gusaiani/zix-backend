defmodule ZixWeb.Notifications.Emails do
  @moduledoc """
  Wrapper module to call email server
  """

  alias Zix.{
    User
  }

  alias ZixWeb.Notifications.{
    Emails.Server,
    UserEmail
  }

  def confirm(%User{} = user), do: GenServer.cast(Server, {UserEmail, :confirm, [user]})

  def change_email(%User{} = user), do: GenServer.cast(Server, {UserEmail, :change_email, [user]})

  def welcome(%User{} = user), do: GenServer.cast(Server, {UserEmail, :welcome, [user]})

  def user_registered(%User{} = user),
    do: GenServer.cast(Server, {UserEmail, :user_registered, [user]})

  def reset_password(%User{} = user),
    do: GenServer.cast(Server, {UserEmail, :reset_password, [user]})
end
