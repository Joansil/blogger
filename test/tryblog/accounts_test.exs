defmodule Tryblog.AccountsTest do
  use Tryblog.DataCase, async: true

  alias Tryblog.Accounts

  describe "user" do
    alias Tryblog.Accounts.User

    @valid_attrs %{
      displayName: "some displayName",
      email: "some@email.com",
      image: "some image",
      password: "somepassword"
    }

    @invalid_attrs %{displayName: nil, email: nil, image: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.displayName == "some displayName"
      assert user.email == "some@email.com"
      assert user.image == "some image"
      assert user.password == "somepassword"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "list_user/0 returns all user" do
      user = user_fixture()
      assert [%{displayName: name, email: email, image: image}] = Accounts.list_user()
      assert user.displayName == name
      assert user.email == email
      assert user.image == image
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()

      assert {:ok, %User{displayName: name, email: email, image: image}} =
               Accounts.get_user!(user.id)

      assert user.displayName == name
      assert user.email == email
      assert user.image == image
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert {:error, :not_found} = Accounts.get_user!(user.id)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
