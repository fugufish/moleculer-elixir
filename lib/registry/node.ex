defmodule Moleculer.Registry.Node do
  @moduledoc """
  Represents a Node on the Molecuer network.
  """
  use Agent

  def start_link(node_spec) do
    {:ok, name} = Map.fetch(node_spec, :sender)

    Agent.start_link(fn -> node_spec end, name: String.to_atom("#{__MODULE__}.#{name}"))
  end

  @doc """
  Returns the node's spec
  """
  def spec(name) do
    Agent.get(module_name(name), fn node_spec -> node_spec end)
  end

  @doc """
  Returns the node's service specs
  """
  def service_specs(name) do
    {:ok, services} = Map.fetch(spec(name), :services)

    services
  end

  defp module_name(name) do
    String.to_atom("#{__MODULE__}.#{name}")
  end
end
