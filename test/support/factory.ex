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
      confirmation_token: "97971cce-eb6e-418a-8529-e717ca1dcf62",
      confirmed: true
    }
  end
end

