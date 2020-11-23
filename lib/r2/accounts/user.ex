defmodule B2.Accounts.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :salutation, :string
    field :firstname, :string
    field :lastname, :string
    field :fullname, :string
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :confirmed_at, :naive_datetime
    field :admin, :boolean, default: false
    belongs_to :tenant, B2.Accounts.Tenant

    timestamps()
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.
  """
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :firstname, :lastname, :salutation, :admin, :confirmed_at, :tenant_id])
    |> validate_required([:firstname, :lastname, :salutation], message: "Please enter a value")
    |> validate_email()
    |> validate_password()
    |> add_fullname()
  end

  defp add_fullname(changeset) do
    case get_field(changeset, :firstname) do
      nil ->
        changeset

      _ ->
        fullname = "#{changeset.changes.firstname} #{changeset.changes.lastname}"
        Ecto.Changeset.change(changeset, %{fullname: fullname})
    end
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email], message: "Please provide a value")
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "Must have the @ sign and no spaces")
    |> validate_length(:email, max: 160, message: "Should be at most 160 character(s)")
    |> unsafe_validate_unique(:email, B2.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password], message: "Please provide a value")
    |> validate_length(:password,
      min: 6,
      max: 80,
      message: "Password should be a min of 6 characters and max of 80 characters"
    )
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> prepare_changes(&hash_password/1)
  end

  defp hash_password(changeset) do
    password = get_change(changeset, :password)

    changeset
    |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
    |> delete_change(:password)
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "Your email did not change")
    end
  end

  @doc """
  A user changeset for changing the password.
  """
  def password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "Your passwords do not match")
    |> validate_password()
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%B2.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Ensure user has confirmed email address
  """

  def confirmed?(user) do
    if !is_nil(user.confirmed_at), do: true
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "Your password is not valid")
    end
  end
end
