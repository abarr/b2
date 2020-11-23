defmodule R2Web.UserRegistrationControllerTest do
  use R2Web.ConnCase, async: true

  import B2.AccountsFixtures

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "Create an account"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(user_fixture()) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/dashboard"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and sends user to login page", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "account" => %{
            "email" => email,
            "password" => valid_user_password(),
            "firstname" => "Joe",
            "lastname" => "Test",
            "salutation" => "Mr",
            "tenant_name" => "Test Tenant"
          }
        })

      response = html_response(conn, 302)

      assert response =~ "<html><body>You are being <a href=\"/users/log_in\">redirected</a>.</body></html>"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "account" => %{
            "email" => "with spaces",
            "password" => "short",
            "firstname" => "Joe",
            "lastname" => "Test",
            "salutation" => "Mr",
            "tenant_name" => unique_tenant_name()
          }
        })

      response = html_response(conn, 200)
      assert response =~ "Create an account"
      assert response =~ "Must have the @ sign and no spaces"
    end
  end
end
