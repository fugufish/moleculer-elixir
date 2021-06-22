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
  alias Moleculer.Registry.Node
  alias Moleculer.Service

  require Logger

  use DynamicAgent

  def start_link(state) do
    Logger.debug("starting node process '#{state[:sender]}'")
    DynamicAgent.start_link(__MODULE__, state, name: state[:sender])
  end

  def init(state) do
    children = [
      %{
        id: :rand.uniform(100_000),
        start:
          {Task, :start_link, [fn -> Node.start_services(state[:sender], state[:services]) end]},
        restart: :transient
      }
    ]

    DynamicAgent.init(children, state, name: state[:sender])
  end

  def fetch(struct, :sender) do
    {:ok, sender} = Map.fetch(struct, :sender)

    {:ok, parse_name(sender)}
  end

  def fetch(struct, key) do
    Map.fetch(struct, key)
  end

  def start_services(node, services) do
    Logger.debug("starting #{Enum.count(services)} service(s) for '#{node}'")
    Enum.each(services, fn service -> start_service(node, service) end)
  end

  def start_service(node, service) when is_struct(service, Service) do
    Logger.debug("starting service '#{Service.Remote.name(service)}' for node '#{node}'")

    start_child(
      node,
      %{
        id: Service.fqn(node, Service.Remote.name(service)),
        start: {Service.Remote, :start_link, [node, service]}
      }
    )
  end

  def start_service(name, service) when is_atom(service) do
  end

  def wait_for_services(node) do
    service_count = Enum.count(services(node))

    if service_count > Enum.count(which_children(node)) do
      wait_for_services(node)
    else
      :ok
    end
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

  defp services_to_string(services) do
    services |> Enum.map(fn service -> service[:name] end) |> Enum.join(", ")
  end
end
