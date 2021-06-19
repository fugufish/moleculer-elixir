defmodule Simple.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Moleculer.Broker, name: "broker"},
      {MathService, name: "math"}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Simple.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
