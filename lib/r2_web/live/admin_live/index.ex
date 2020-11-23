defmodule R2Web.AdminLive.Index do
  @moduledoc false
  use R2Web, :live_view

  alias B2.Accounts

  @impl true
  def mount(_params, %{"user_token" => token}, socket) do
    socket =
      socket
      |> assign(current_user: Accounts.get_user_by_session_token(token))
      |> assign(customers: Accounts.list_tenants())

    {:ok, socket}
  end
end
