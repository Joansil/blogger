defmodule TryblogWeb.UserController do
  use TryblogWeb, :controller

  alias Tryblog.Accounts
  alias Tryblog.Accounts.User
  alias Tryblog.Guardian

  action_fallback TryblogWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_user()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("login.json", token: token)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Accounts.get_user!(id) do
      render(conn, "show.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, _) do
    with {:ok, %User{} = user} <- Guardian.Plug.current_resource(conn),
         {:ok, %User{} = user} <- Accounts.get_user!(user.id),
         {:ok, %User{}} <- Accounts.delete_user(user) do
      token = Guardian.Plug.current_token(conn)
      Guardian.revoke(token)

      conn
      |> Guardian.Plug.sign_out()
      |> send_resp(:no_content, "")
    end
  end
end
