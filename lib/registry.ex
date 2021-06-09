defmodule Moleculer.Registry do
  @defmodule """
  Moleculer has a built-in service registry module. It stores all information about services,
  actions, event listeners and nodes. When you call a service or emit an event, broker asks the
  registry to look up a node which is able to execute the request. If there are multiple nodes,
  it uses load-balancing strategy to select the next node.
  """

  use Supervisor

  def start_link(_) do
    children = []

    Supervisor.start_link(__MODULE__, children, strategy: :one_for_one, name: __MODULE__)
  end
end
