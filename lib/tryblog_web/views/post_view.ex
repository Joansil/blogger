defmodule TryblogWeb.PostView do
  use TryblogWeb, :view

  alias TryblogWeb.PostView
  alias TryblogWeb.UserView

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post_and_user.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post_and_user.json")}
  end

  def render("create.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{
      post_id: post.id,
      title: post.title,
      content: post.content,
      user_id: post.user_id
    }
  end

  def render("post_and_user.json", %{post: post}) do
    %{
      post_id: post.id,
      title: post.title,
      content: post.content,
      published: post.inserted_at,
      updated: post.updated_at,
      user: render_one(post.user, UserView, "user.json")
    }
  end
end
