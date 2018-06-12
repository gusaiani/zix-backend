defmodule Zix.UserTest do
  use Zix.ModelCase

  alias Zix.{
    Repo,
    User
  }

  import Zix.Factory

  @valid_attrs %{
    email: "validemail@emcasa.com",
    password: "validpassword",
  }
  @invalid_attrs %{
    email: "invalidemail",
    password: "",
  }

  test "changeset with valid attributes" do
    changeset = User.create_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.create_changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
    assert Keyword.get(changeset.errors, :email) == {"has invalid format", [validation: :format]}
    assert Keyword.get(changeset.errors, :password) == {"can't be blank", [validation: :required]}

  end

  test "duplicated email should be invalid" do
    insert(:user, @valid_attrs)

    {:error, changeset} =
      %User{}
      |> User.create_changeset(@valid_attrs)
      |> Repo.insert()

    assert changeset.errors == [email: {"has already been taken", []}]
  end
end
