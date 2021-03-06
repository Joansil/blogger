defmodule Tryblog.Guardian.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :blog,
    error_handler: Tryblog.Guardian.ErrorHandler,
    module: Tryblog.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
