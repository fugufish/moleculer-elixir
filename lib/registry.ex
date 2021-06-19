defmodule Moleculer.Registry do
  @moduledoc """
  Moleculer has a built-in service registry module. It stores all information about services,
  actions, event listeners and nodes. When you call a service or emit an event, broker asks the
  registry to look up a node which is able to execute the request. If there are multiple nodes,
  it uses load-balancing strategy to select the next node.
  """

  require Logger

  use Supervisor

  alias Moleculer.Registry.NodeCatalog

  def start_link() do
    Supervisor.start_link(__MODULE__, [], strategy: :one_for_one, name: __MODULE__)
  end

  @impl true
  def init(_) do
    Logger.info("Starting registry...")

    children = [
      NodeCatalog,
      {Task, [fn -> NodeCatalog.add(__MODULE__.LocalNode) end], strategy: :transient}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def add_node(name) do
    NodeCatalog.add(name)
  end
end
