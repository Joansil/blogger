defmodule Tryblog.Repo do
  use Ecto.Repo,
    otp_app: :tryblog,
    adapter: Ecto.Adapters.Postgres
end
