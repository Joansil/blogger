defmodule TryblogWeb.Router do
  use TryblogWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authorize do
    plug Tryblog.Guardian.Pipeline
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", TryblogWeb do
    pipe_through [:api]

    post "/user", UserController, :create
    post "/login", LoginController, :login
  end

  scope "/", TryblogWeb do
    pipe_through [:api, :authorize]

    get "/user", UserController, :index
    get "/user/:id", UserController, :show
    delete "/user/me", UserController, :delete

    post "/post", PostController, :create
    get "/post", PostController, :index
    get "/post/search", PostController, :search
    get "/post/:id", PostController, :show
    put "/post/:id", PostController, :update
    delete "/post/:id", PostController, :delete
  end
end

# Enables LiveDashboard only for development
#
# If you want to use the LiveDashboard in production, you should put
# it behind authentication and allow only admins to access it.
# If your application does not have an admins-only section yet,
# you can use Plug.BasicAuth to set up some basic authentication
# as long as you are also using SSL (which you should anyway).
# if Mix.env() in [:dev, :test] do
#  import Phoenix.LiveDashboard.Router
#
#  scope "/" do
#    pipe_through [:fetch_session, :protect_from_forgery]
#    live_dashboard "/dashboard", metrics: TryblogWeb.Telemetry
#  end
# end
