defmodule Tryblog.Blog.Post do
  use Ecto.Schema

  alias Tryblog.Accounts.User

  import Ecto.Changeset
  import Ecto.Query, warn: false

  @required_params [:user_id, :title, :content]

  @update_params [:title, :content]

  schema "posts" do
    field(:title, :string)
    field(:content, :string)

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def post_changeset(post, attrs) do
    post
    |> cast(attrs, @required_params)
    |> validate_required(@required_params)
  end

  def post_update_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @update_params)
    |> validate_required(@update_params)
  end

  def search_post(search) do
    from(s in __MODULE__,
      where: ilike(s.title, ^"%#{search}%") or ilike(s.content, ^"%#{search}%")
    )
  end
end
