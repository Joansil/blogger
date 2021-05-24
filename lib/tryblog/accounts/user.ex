defmodule Tryblog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Argon2

  @derive {Jason.Encoder, [:displayName, :email, :image]}

  @required_params [:displayName, :email, :image, :password]

  @to_login [:email, :password]

  schema "users" do
    field :displayName, :string
    field :email, :string
    field :image, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def user_changeset(user, attrs) do
    user
    |> cast(attrs, @required_params ++ [:password_hash])
    |> validate_required(@required_params)
    |> validate_length(:displayName, min: 8)
    |> validate_format(:email, ~r/[A-Za-z0-9._]+@[A-Za-z]+(.(com|br))+/)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

  def to_login_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @to_login)
    |> validate_required(@to_login)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_params)
  end

  def confirm_password(user, password) do
    if Argon2.verify_pass(password, user.password_hash) do
      user
    else
      false
    end
  end
end
