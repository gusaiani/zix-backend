defmodule ZixWeb.GuardianPipeline do
  @moduledoc """
  Module to define guardian related plugs into a pipeline
  """
  @claims %{typ: "access"}

  use Guardian.Plug.Pipeline,
    otp_app: :re,
    module: ZixWeb.Guardian,
    error_handler: ZixWeb.Guardian.AuthErrorHandler

  plug(Guardian.Plug.VerifySession, claims: @claims)
  plug(Guardian.Plug.VerifyHeader, claims: @claims, realm: "Token")
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
