defmodule R2Web.UserConfirmationControllerTest do
  use R2Web.ConnCase, async: true

  alias B2.Accounts
  alias B2.Repo
  import B2.AccountsFixtures

  setup do
    %{tenant: tenant_fixture(), user: user_fixture(), unconfirmed_user: unconfirmed_user_fixture(), }
  end

  describe "GET /users/confirm" do
    test "renders the confirmation page", %{conn: conn} do
      conn = get(conn, Routes.user_confirmation_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "Resend confirmation instructions"
    end
  end

  describe "POST /users/confirm" do
    test "sends a new confirmation token", %{conn: conn, unconfirmed_user: unconfirmed_user} do

      conn =
        post(conn, Routes.user_confirmation_path(conn, :create), %{
          "user" => %{"email" => unconfirmed_user.email}
        })

      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.get_by!(Accounts.UserToken, user_id: unconfirmed_user.id).context == "confirm"
    end

    test "does not send confirmation token if account is confirmed", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_confirmation_path(conn, :create), %{
          "user" => %{"email" => user.email}
        })

      assert get_flash(conn, :info) =~ "If your email is in our system"
      refute Repo.get_by(Accounts.UserToken, user_id: user.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.user_confirmation_path(conn, :create), %{
          "user" => %{"email" => "unknown@example.com"}
        })

      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.all(Accounts.UserToken) == []
    end
  end

  describe "GET /users/confirm/:token" do
    test "confirms the given token once", %{conn: conn, unconfirmed_user: unconfirmed_user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_confirmation_instructions(unconfirmed_user, url)
        end)

      conn = get(conn, Routes.user_confirmation_path(conn, :confirm, token))

      assert get_flash(conn, :info) =~
               "Account confirmed successfully. It's now time to test your account."

      assert Accounts.get_user!(unconfirmed_user.id).confirmed_at
      refute get_session(conn, :user_token)
      assert Repo.all(Accounts.UserToken) == []

      conn = get(conn, Routes.user_confirmation_path(conn, :confirm, token))
      assert get_flash(conn, :error) =~ "Confirmation link is invalid or it has expired"
    end

    test "does not confirm email with invalid token", %{conn: conn, unconfirmed_user: user} do
      conn = get(conn, Routes.user_confirmation_path(conn, :confirm, "oops"))
      assert get_flash(conn, :error) =~ "Confirmation link is invalid or it has expired"
      refute Accounts.get_user!(user.id).confirmed_at
    end
  end
end
