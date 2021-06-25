defmodule Moleculer.Registry do
  @moduledoc """
  Moleculer has a built-in service registry module. It stores all information about services,
  actions, event listeners and nodes. When you call a service or emit an event, broker asks the
  registry to look up a node which is able to execute the request. If there are multiple nodes,
  it uses load-balancing strategy to select the next node.
  """

  alias Moleculer.{Registry.Node, Service}

  require Logger

  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], strategy: :one_for_one, name: __MODULE__)
  end

  @impl true
  def init(_) do
    Logger.info("Starting registry...")

    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: __MODULE__.DynamicSupervisor},
      {Registry, keys: :unique, name: __MODULE__.NodeRegistry},
      {Registry, keys: :unique, name: __MODULE__.ServiceRegistry},
      {Registry, keys: :unique, name: __MODULE__.ActionRegistry}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc """
  Adds a node to the registry.
  """
  @spec add_node(spec :: Node.t()) :: {:ok, pid()}
  def add_node(spec) when is_struct(spec, Node) do
    name = Node.name(spec)
    Logger.info("adding node '#{name}'")

    {:ok, pid} = DynamicSupervisor.start_child(__MODULE__.DynamicSupervisor, {Node, spec})

    Node.wait_for_services(spec)

    Registry.register(__MODULE__.NodeRegistry, name, pid)
    register_services(name)

    {:ok, pid}
  end

  @doc """
  Looks up an existing node in the reistry by name returning the pid for the node.
  """
  @spec lookup_node(node :: atom()) :: pid()
  def lookup_node(node) do
    Registry.lookup(__MODULE__.NodeRegistry, node)
    |> Enum.map(fn list ->
      {pid, _} = list

      pid
    end)
    |> Enum.at(0, nil)
  end

  @doc """
  Looks up service pids for the given service name.
  """
  @spec lookup_services(node :: atom()) :: list(pid())
  def lookup_services(name) do
    Registry.lookup(__MODULE__.ServiceRegistry, name)
    |> Enum.map(fn service ->
      {pid, _} = service
      pid
    end)
  end

  @doc """
  Looks up the services that provide the given action. Actions are in the format of `:"service-name.action-name"`.
  """
  @spec lookup_services_for_action(node :: atom()) :: list(pid)
  def lookup_services_for_action(action) do
    [service_name, action_name] = action |> Atom.to_string() |> String.split(".")

    Registry.lookup(__MODULE__.ActionRegistry, Module.concat(service_name, action_name))
    |> Enum.map(fn list ->
      {pid, _} = list
      pid
    end)
  end

  defp register_services(name) do
    services = Node.services(name)

    Enum.each(services, fn {key, value} ->
      Registry.register(__MODULE__.ServiceRegistry, key, value)
      register_actions(value)
    end)
  end

  defp register_actions(pid) do
    actions = Service.actions(pid)
    name = Service.name(pid)

    Enum.each(actions, fn {key, value} ->
      Registry.register(__MODULE__.ActionRegistry, Module.concat(name, key), value)
    end)
  end
end
