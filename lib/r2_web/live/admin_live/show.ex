defmodule R2Web.AdminLive.Show do
  @moduledoc false
  use R2Web, :live_view

  alias B2.Accounts

  @impl true
  def mount(_params, %{"user_token" => token}, socket) do
    socket =
      socket
      |> assign(current_user: Accounts.get_user_by_session_token(token))

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    socket =
      socket
      |> assign(tenant: Accounts.get_tenant!(id))

    {:noreply, socket}
  end
end
