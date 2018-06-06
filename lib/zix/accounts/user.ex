defmodule Zix.User do
  @moduledoc """
  Model for users.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Comeonin.Bcrypt

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @create_required ~w(email password)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @create_required ++ @optional)
    |> validate_required(@create_required)
    |> base_changeset()
    |> hash_password()
  end

  defp base_changeset(changeset) do
    changeset
    |> validate_email()
    |> unique_constraint(:email)
    |> validate_inclusion(:role, @roles, message: "should be one of: [#{Enum.join(@roles, " ")}]")
  end

  defp validate_email(changeset) do
    changeset
    |> get_field(:email)
    |> EmailChecker.valid?()
    |> case do
      true -> changeset
      false -> add_error(changeset, :email, "has invalid format", validation: :format)
    end
  end

  defp hash_password(%{valid?: false} = changeset), do: changeset

  defp hash_password(changeset) do
    password_hash =
      changeset
      |> get_change(:password)
      |> Bcrypt.hashpwsalt()

    put_change(changeset, :password_hash, password_hash)
  end
end
