defmodule Moleculer.Registry.Node do
  @derive [Poison.Encoder]
  @enforce_keys [:sender]

  defstruct [:sender, ver: 4, services: []]

  @type t :: %__MODULE__{
          ver: non_neg_integer(),
          sender: String.t() | atom(),
          services: list(Moleculer.Service.t())
        }

  @moduledoc """
  Represents a Node on the Moleculer network.
  """

  alias Moleculer.DynamicAgent
  use DynamicAgent

  def start_link(state) do
    DynamicAgent.start_link(__MODULE__, state, name: state[:sender])
  end

  def init(state) do
    children = state[:services]

    DynamicAgent.init(children, state, name: state[:sender])
  end

  def fetch(struct, :sender) do
    {:ok, sender} = Map.fetch(struct, :sender)

    {:ok, parse_name(sender)}
  end

  def fetch(struct, key) do
    Map.fetch(struct, key)
  end

  def services(node) do
    DynamicAgent.get(node, fn struct -> struct[:services] end)
  end

  def name(node) do
    DynamicAgent.get(node, fn struct -> struct[:sender] end)
  end

  defp parse_name(name) when is_binary(name) do
    String.to_atom(name)
  end

  defp parse_name(name) when is_atom(name) do
    name
  end
end
