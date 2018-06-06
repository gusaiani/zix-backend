defmodule Zix.Factory do
  @moduledoc """
  Use the factories here in tests.
  """

  use ExMachina.Ecto, repo: Zix.Repo

  alias Faker.{Name, Address, Internet, Pokemon, Lorem.Shakespeare, Phone}
  alias Comeonin.Bcrypt

  def user_factory do
    %Zix.User{
      email: Internet.email(),
      password_hash: Bcrypt.hashpwsalt("password"),
    }
  end
end

