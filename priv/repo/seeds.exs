# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Zix.Repo.insert!(%Zix.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Zix.{
  Repo,
  User
}

alias Comeonin.Bcrypt

Repo.delete_all(User)

Repo.insert(%User{
  email: "user@amazix.com",
  password_hash: Bcrypt.hashpwsalt("password"),
})


