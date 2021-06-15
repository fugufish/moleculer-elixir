defmodule Moleculer.Service.Remote do
  # use Moleculer.Service

  def start_link(node, state) do
    Moleculer.Service.start_link(__MODULE__, state, name: state[:name])
  end

  def name(state) do
    state[:name]
  end
end
