defmodule Moleculer.Registry.Node do
  @derive [Poison.Encoder]
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
  use Moleculer.DynamicAgent

  def start_link(state) do
    Moleculer.DynamicAgent.start_link(__MODULE__, state, name: state[:sender])
  end

  def init(state) do
    children = []

    Moleculer.DynamicAgent.init(children, state, name: state[:sender])
  end

  def fetch(struct, :sender) do
    {:ok, sender} = Map.fetch(struct, :sender)

    {:ok, String.to_atom(sender)}
  end

  def fetch(struct, key) do
    Map.fetch(struct, key)
  end

  def services(node) do
    Agent.get(agent_name(node), fn struct -> struct[:services] end)
  end

  def name(node) do
    Agent.get(agent_name(node), fn struct -> struct[:sender] end)
  end
end
