defmodule Tryblog.Blog do
  @moduledoc """
  The Blog context.
  """
  import Ecto.Query, warn: false

  alias Tryblog.Blog.Post
  alias Tryblog.Repo

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts, do: Repo.all(Post)

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    {:ok, Repo.get!(Post, id)}
  rescue
    Ecto.NoResultsError -> {:error, :not_found}
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(user, attrs \\ %{}) do
    attrs = post_parameters(user, attrs)

    %Post{}
    |> Post.post_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    case Post.post_update_changeset(attrs) do
      %Ecto.Changeset{valid?: true} ->
        post
        |> Post.post_changeset(attrs)
        |> Repo.update()

      error ->
        {:error, error}
    end
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(user, %Post{} = post) do
    cond do
      user.id == post.user_id -> Repo.delete(post)
      true -> {:error, :unauthorized}
    end
  end

  def preload_user(post), do: Repo.preload(post, :user)

  def search_blog(looking_post) do
    looking_post |> Post.search_post() |> Repo.all()
  end

  defp post_parameters(user, %{title: _} = attrs) do
    Map.put(attrs, :user_id, user.id)
  end

  defp post_parameters(user, %{"title" => _} = attrs) do
    Map.put(attrs, "user_id", user.id)
  end

  defp post_parameters(user, %{}), do: %{user_id: user.id}
end
