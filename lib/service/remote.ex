defmodule Moleculer.Service.Remote do
  use Moleculer.Service

  alias Moleculer.Service

  def start_link(node, spec) do
    service = %Service{
      name: spec[:name],
      node: node,
      settings: spec[:settings]
    }

    Service.start_link(__MODULE__, service)
  end

  def name(state) do
    state[:name]
  end

  def settings(state) do
    state[:settings]
  end
end
