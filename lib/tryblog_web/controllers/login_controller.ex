defmodule TryblogWeb.LoginController do
  use TryblogWeb, :controller

  alias Tryblog.Accounts
  alias Tryblog.Accounts.User
  alias Tryblog.Guardian

  action_fallback TryblogWeb.FallbackController

  def login(conn, params) do
    with {:ok, %User{} = user} <- Accounts.authentication_user(params),
         {:ok, token, _} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:ok)
      |> render("login.json", token: token)
    else
      {:error, :invalid_credentials} ->
        conn
        |> put_status(:bad_request)
        |> json(%{data: %{message: "campos inválidos"}})

      error ->
        TryblogWeb.FallbackController.call(conn, error)
    end
  end
end
