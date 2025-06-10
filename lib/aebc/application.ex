defmodule Aebc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AebcWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:aebc, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Aebc.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Aebc.Finch},
      # Start a worker by calling: Aebc.Worker.start_link(arg)
      # {Aebc.Worker, arg},
      # Start to serve requests, typically the last entry
      AebcWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Aebc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AebcWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
