defmodule TryblogWeb.PostController do
  use TryblogWeb, :controller

  alias Tryblog.Blog
  alias Tryblog.Blog.Post
  alias Tryblog.Guardian

  action_fallback TryblogWeb.FallbackController

  def index(conn, _params) do
    posts = Blog.list_posts()
    render(conn, "index.json", posts: Blog.preload_user(posts))
  end

  def create(conn, %{"post" => post_params}) do
    with {:ok, user} <- Guardian.Plug.current_resource(conn),
         {:ok, %Post{} = post} <- Blog.create_post(user, post_params) do
      conn
      |> put_status(:created)
      |> render("create.json", post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Post{} = post} <- Blog.get_post!(id) do
      render(conn, "show.json", post: Blog.preload_user(post))
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    with {:ok, %Post{} = post} <- Blog.get_post!(id),
         {:ok, %Post{} = post} <- Blog.update_post(post, post_params) do
      render(conn, "create.json", post: post)
    end
  end

  def search(conn, %{"q" => params}) do
    posts = Blog.search_blog(params)
    render(conn, "index.json", posts: Blog.preload_user(posts))
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, user} <- Guardian.Plug.current_resource(conn),
         {:ok, %Post{} = post} <- Blog.get_post!(id),
         {:ok, %Post{}} <- Blog.delete_post(user, post) do
      send_resp(conn, :no_content, "")
    else
      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{errors: %{message: "Usuário não autorizado"}})

      error ->
        TryblogWeb.FallbackController.call(conn, error)
    end
  end
end
