defmodule Tryblog.BlogTest do
  use Tryblog.DataCase, async: true

  alias Tryblog.Accounts
  alias Tryblog.Blog

  describe "posts" do
    alias Tryblog.Blog.Post

    @valid_attrs %{content: "some content", title: "some title"}
    @update_attrs %{content: "some updated content", title: "some updated title"}
    @invalid_attrs %{content: nil, title: nil}

    @user_params %{
      displayName: "some name",
      email: "some@email.com",
      image: "some image",
      password: "somepassword"
    }

    def post_fixture() do
      test_user = created_user_test()

      {:ok, post} = Blog.create_post(test_user, @valid_attrs)

      post
    end

    def created_user_test(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@user_params)
        |> Accounts.create_user()

      user
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert [%{user_id: user_id, title: title, content: content}] = Blog.list_posts()
      assert post.user_id == user_id
      assert post.title == title
      assert post.content == content
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert assert {:ok, post} == Blog.get_post!(post.id)
    end

    test "create_post/1 with valid data creates a post" do
      test_user = created_user_test()
      assert {:ok, %Post{} = _post} = Blog.create_post(test_user, @valid_attrs)
    end

    test "create_post/1 with invalid data returns error changeset" do
      test_user = created_user_test()
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(test_user, @invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Blog.update_post(post, @update_attrs)
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert {:ok, post} == Blog.get_post!(post.id)
    end

    test "search_blog/1 search on the posts" do
      post = post_fixture()
      assert [%{title: title, content: content}] = Blog.search_blog("some")
      assert post.title == title
      assert post.content == content
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture() |> Blog.preload_user()
      assert {:ok, %Post{}} = Blog.delete_post(post.user, post)
      assert {:error, :not_found} = Blog.get_post!(post.id)
    end
  end
end
