defmodule ZixWeb.Router do
  use ZixWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ZixWeb do
    pipe_through :api
  end
end
