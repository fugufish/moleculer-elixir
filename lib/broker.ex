defmodule Moleculer.Broker do
  @moduledoc """
  The Broker is the main component of Moleculer. It handles services,
  calls actions, emits events and communicates with remote nodes. You must 
  create a Broker instance on every node.
  """

  require Logger

  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, [], strategy: :one_for_one, name: Moleculer.Broker)
  end

  def init(_) do
    Logger.info("Starting Moleculer (Elixir) #{Moleculer.version()}...")
    Logger.info("Namespace: #{namespace()}")
    Logger.info("Node ID: #{node_id()}")

    children = [
      Moleculer.Registry
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc """
  Namespace of nodes to segment your nodes on the same network (e.g.: 
  “development”, “staging”, “production”). Default: ""
  """
  def namespace do
    Application.get_env(:moleculer, :namespace, "")
  end

  def node_id do
    Application.get_env(:moleculer, :node_id, Moleculer.Utils.get_node_id())
  end
end
