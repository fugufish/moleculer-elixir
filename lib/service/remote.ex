defmodule Moleculer.Service.Remote do
  use Moleculer.Service

  alias Moleculer.Service

  @impl true
  def name(state) do
    state[:name]
  end

  @impl true
  def settings(state) do
    state[:settings]
  end

  @impl true
  def actions(state) do
    state[:actions]
  end
end
