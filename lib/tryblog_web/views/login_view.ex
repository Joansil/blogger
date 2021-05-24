defmodule TryblogWeb.LoginView do
  use TryblogWeb, :view

  alias TryblogWeb.LoginView

  def render("login.json", %{token: token}) do
    %{data: render_one(token, LoginView, "token.json")}
  end

  def render("token.json", %{login: token}) do
    %{token: token}
  end
end
