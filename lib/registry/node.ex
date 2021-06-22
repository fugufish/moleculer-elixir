defmodule Moleculer.Registry.Node do
  alias Moleculer.{Registry.Node, Service, Utils}

  require Logger

  import Utils.Naming

  use Supervisor

  @derive [Poison.Encoder]
  @enforce_keys [:sender]

  defstruct [:sender, ver: 4, services: []]

  @type t :: %__MODULE__{
          ver: non_neg_integer(),
          sender: String.t() | atom(),
          services: list(Service.t())
        }

  @moduledoc """
  Represents a Node on the Moleculer network.
  """

  def start_link(state) do
    Supervisor.start_link(
      __MODULE__,
      state,
      name: Module.concat(__MODULE__, Node.name(state))
    )
  end

  def init(state) do
    name = Node.name(state)

    children = [
      %{
        id: agent_name(name),
        start: {Agent, :start_link, [fn -> state end, [name: agent_name(name)]]}
      },
      {DynamicSupervisor, strategy: :one_for_one, name: dynamic_supervisor_name(name)},
      {Registry, keys: :unique, name: registry_name(name)},
      %{
        id: :rand.uniform(1_000_000),
        start: {Task, :start_link, [fn -> start_services(name) end]},
        strategy: :transient
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def name(state) when is_struct(state, Node) do
    state[:sender]
  end

  def name(node) when is_atom(node) do
    Agent.get(agent_name(node), fn struct -> struct[:sender] end)
  end

  def fetch(struct, :sender) do
    {:ok, sender} = Map.fetch(struct, :sender)

    {:ok, parse_name(sender)}
  end

  def fetch(struct, key) do
    Map.fetch(struct, key)
  end

  def start_services(node) do
    service_list = services(node)
    node_name = name(node)

    Logger.debug("starting #{Enum.count(service_list)} service(s) for '#{node_name}'")

    Enum.each(service_list, fn service -> start_service(node_name, service) end)
  end

  def start_service(node_name, service) when is_struct(service, Service) do
    Logger.debug("starting service '#{Service.Remote.name(service)}' for node '#{node_name}'")

    {:ok, pid} =
      DynamicSupervisor.start_child(
        dynamic_supervisor_name(node_name),
        %{
          id: Service.fqn(node_name, Service.Remote.name(service)),
          start: {Service.Remote, :start_link, [node_name, service]}
        }
      )

    Registry.register(registry_name(node_name), Service.Remote.name(service), pid)

    {:ok, pid}
  end

  def start_service(name, service) when is_atom(service) do
  end

  def wait_for_services(node) do
    service_count = Enum.count(services(node))

    if service_count >
         dynamic_supervisor_name(node) |> DynamicSupervisor.which_children() |> Enum.count() do
      wait_for_services(node)
    else
      :ok
    end
  end

  def services(node) when is_struct(node, Node) do
    node[:services]
  end

  def services(node) when is_atom(node) do
    Agent.get(agent_name(node), fn struct -> struct[:services] end)
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
