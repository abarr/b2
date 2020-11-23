defmodule B2.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      B2.Repo,
      # Start the Telemetry supervisor
      R2Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: B2.PubSub},
      # Start the Endpoint (http/https)
      R2Web.Endpoint
      # Start a worker by calling: B2.Worker.start_link(arg)
      # {B2.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: B2.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    R2Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
