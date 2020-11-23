defmodule R2Web.UserRegistrationController do
  use R2Web, :controller
  require Logger
  alias B2.Accounts
  alias B2.Accounts.{Mailer}
  alias B2.Accounts.Account
  alias B2.Data.ReferenceData

  plug :put_root_layout, {R2Web.LayoutView, "blank.html"}

  def new(conn, _params) do

    changeset = Accounts.change_account_registration(%Account{})
    Logger.info("Creating registration changeset: #{inspect(changeset)}")

    salutations = ReferenceData.get("salutations")
    Logger.info("Loading salutation from RefData lib: #{inspect(salutations)}")

    Logger.info("Rendering new account page")
    render(conn, "new.html", changeset: changeset, salutations: salutations)
  end

  def create(conn, %{"account" => params}) do
    case Accounts.create_new_account(params) do
      {:ok, %{tenant: _tenant, user: user}} ->
        # Send email to confirm User Account
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          ) |> Mailer.deliver

        conn
        |> put_flash(:info, "Check your email to confirm account :)")
        |> redirect(to: Routes.user_session_path(conn, :new))

      {:error, _operation, repo_changeset, _changes} ->
        salutations = ReferenceData.get("salutations")
        changeset = Accounts.change_account_registration(%Account{}, params)
        changeset = copy_errors(repo_changeset, changeset)

        render(conn, "new.html",
          changeset: %{changeset | action: :insert},
          salutations: salutations
        )
    end
  end

  defp copy_errors(from, to) do
    Enum.reduce(from.errors, to, fn {field, {msg, additional}}, acc ->
      Ecto.Changeset.add_error(acc, field, msg, additional: additional)
    end)
  end
end
