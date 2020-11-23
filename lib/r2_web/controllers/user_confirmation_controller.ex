defmodule R2Web.UserConfirmationController do
  use R2Web, :controller

  alias B2.Accounts
  alias B2.Accounts.Mailer

  plug :put_root_layout, {R2Web.LayoutView, "blank.html"}

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email}}) do

    if user = Accounts.get_user_by_email(email) do

      case Accounts.deliver_user_confirmation_instructions(
        user,
        &Routes.user_confirmation_url(conn, :confirm, &1)
      ) do
        {:error, :already_confirmed} ->
          nil
        email ->
          Mailer.deliver(email)
      end
    end
    # Regardless of the outcome, show an impartial success/error message.
    conn
    |> put_flash(
      :info,
      "If your email is in our system and it has not been confirmed yet, " <>
        "you will receive an email with instructions shortly."
    )
    |> redirect(to: Routes.user_session_path(conn, :new))
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def confirm(conn, %{"token" => token}) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Account confirmed successfully. It's now time to test your account.")
        |> redirect(to: Routes.user_session_path(conn, :new))

      :error ->
        conn
        |> put_flash(:error, "Confirmation link is invalid or it has expired. ")
        |> render("new.html")
    end
  end
end
