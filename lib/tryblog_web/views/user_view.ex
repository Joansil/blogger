defmodule TryblogWeb.UserView do
  use TryblogWeb, :view

  alias TryblogWeb.LoginView
  alias TryblogWeb.UserView

  def render("login.json", %{token: token}) do
    %{data: render_one(token, LoginView, "token.json")}
  end

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      user_id: user.id,
      displayName: user.displayName,
      email: user.email,
      image: user.image
    }
  end
end
