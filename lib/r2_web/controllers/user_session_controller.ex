defmodule R2Web.UserSessionController do
  use R2Web, :controller

  alias B2.Accounts
  alias R2Web.UserAuth

  plug :put_root_layout, {R2Web.LayoutView, "blank.html"}

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(
        conn,
        %{"email" => email, "password" => password, "remember_me" => _remember_me} = user_params
      ) do
    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      conn
      |> put_flash(
        :error,
        "Your email or password were invalid or you have not confirmed your email address!"
      )
      |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> UserAuth.log_out_user()
  end
end
