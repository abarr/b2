defmodule R2Web.Router do
  use R2Web, :router

  import R2Web.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {R2Web.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  # scope "/api", R2Web do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    if Mix.env() == :dev do
      scope "/dev" do
        pipe_through [:browser]
        forward "/mailbox", Plug.Swoosh.MailboxPreview, base_path: "/dev/mailbox"
      end
    end

    scope "/" do
      pipe_through :browser
      live_dashboard "/live_dashboard", metrics: R2Web.Telemetry
    end
  end

  ## Authentication routes
  scope "/", R2Web do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/", HomeController, :index
    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", R2Web do
    pipe_through [:browser, :require_authenticated_user, :redirect_if_admin]

    live "/dashboard", DashboardLive.Index

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings/update_password", UserSettingsController, :update_password
    put "/users/settings/update_email", UserSettingsController, :update_email
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", R2Web do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  scope "/admin", R2Web do
    pipe_through [:browser, :require_authenticated_user, :ensure_is_admin]

    live "/dashboard", AdminLive.Index, layout: {R2Web.LayoutView, "admin.html"}
    live "/customer", AdminLive.Show, layout: {R2Web.LayoutView, "admin.html"}
  end
end