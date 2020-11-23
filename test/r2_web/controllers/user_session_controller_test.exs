defmodule R2Web.UserSessionControllerTest do
  use R2Web.ConnCase, async: true

  import B2.AccountsFixtures

  setup do
    %{tenant: tenant_fixture(), user: user_fixture()}
  end

  describe "GET /users/log_in" do
    test "renders log in page", %{conn: conn} do
      conn = get(conn, Routes.user_session_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "Sign in to your account"
    end

    test "redirects if already logged in", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get(Routes.user_session_path(conn, :new))
      assert redirected_to(conn) == "/dashboard"
    end
  end


  describe "POST /users/log_in" do
    @tag :error
    test "logs the user in", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "email" => user.email,
          "password" => valid_user_password(),
          "remember_me" => false
        })
      assert get_session(conn, :user_token)

    end

    test "logs the user in with remember me", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "email" => user.email,
          "password" => valid_user_password(),
          "remember_me" => "true"
        })

      assert conn.resp_cookies["user_remember_me"]
      assert redirected_to(conn) =~ "/dashboard"
    end

    test "emits error message with invalid credentials", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "email" => user.email,
          "password" => "invalid_password",
          "remember_me" => false
        })

      response = html_response(conn, 200)
      assert response =~ "Sign in to your account"
    end
  end

  describe "DELETE /users/log_out" do
    test "logs the user out", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> delete(Routes.user_session_path(conn, :delete))
      assert redirected_to(conn) == "/users/log_in"
      refute get_session(conn, :user_token)
    end

    test "succeeds even if the user is not logged in", %{conn: conn} do
      conn = delete(conn, Routes.user_session_path(conn, :delete))
      refute get_session(conn, :user_token)
    end
  end
end
