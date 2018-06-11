defmodule ZixWeb.Router do
  use ZixWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(ZixWeb.GuardianPipeline)
  end


  scope "/users", ReWeb do
    pipe_through(:api)

    post("/login", UserController, :login)
    post("/register", UserController, :register)
    post("/reset_password", UserController, :reset_password)
    post("/redefine_password", UserController, :redefine_password)
    post("/edit_password", UserController, :edit_password)

    put("/change_email", UserController, :change_email)
    put("/confirm", UserController, :confirm)
  end

end
