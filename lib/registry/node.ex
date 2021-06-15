defmodule Moleculer.Registry.Node do
  @enforce_keys [:sender]

  defstruct [:sender, ver: 4, services: []]

  @type t :: %__MODULE__{
          ver: non_neg_integer(),
          sender: String.t(),
          services: list(Moleculer.Service.t())
        }

  @moduledoc """
  Represents a Node on the Molecuer network.
  """
  use Agent

  def start_link(node_spec) do
    Agent.start_link(fn -> node_spec end, name: node_spec[:sender])
  end

  def fetch(struct, :sender) do
    {:ok, sender} = Map.fetch(struct, :sender)

    {:ok, String.to_atom(sender)}
  end

  def fetch(struct, key) do
    Map.fetch(struct, key)
  end

  def services(node) do
    Agent.get(node, fn struct -> struct[:services] end)
  end

  def name(node) do
    Agent.get(node, fn struct -> struct[:sender] end)
  end
end
